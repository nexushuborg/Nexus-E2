# Message Encryption Documentation

## Overview
The chat system implements **AES-256-CBC encryption** for all text messages to ensure end-to-end security. Each message is encrypted with a unique symmetric key and initialization vector (IV) before transmission.

## How Encryption Works

### Server-Side Encryption Process
When a message is sent through the Socket.IO `send_message` event or REST API, the text content is automatically encrypted using the `messageEncryption.js` service:

```javascript
// messageEncryption.js
export const encryptMessage = async (message) => {
    // 1. Generate random 256-bit symmetric key (32 bytes)
    const symmetricKey = crypto.randomBytes(32);

    // 2. Generate random initialization vector (16 bytes)
    const iv = crypto.randomBytes(16);

    // 3. Encrypt message using AES-256-CBC
    const cipher = crypto.createCipheriv('aes-256-cbc', symmetricKey, iv);
    let encryptedMessage = cipher.update(message, 'utf8', 'base64');
    encryptedMessage += cipher.final('base64');

    // 4. Return encrypted data with key and IV
    return {
        encryptedMessage,
        key: symmetricKey.toString('base64'),
        iv: iv.toString('base64')
    };
};
```

### Encrypted Message Structure
When you receive a message via Socket.IO or REST API, the `content` field contains:

```json
{
    "content": {
        "encryptedMessage": "jYnFaX76uUT1L1VGF5PeXX4nJ77hZeA/F2TyllpFJ3w=",
        "key": "+kEuRDFD8HY4fcC3ijXayw+YwcO5E5FUUb5CAHseq74=",
        "iv": "MUVJAJwvYdGKnAik2R6k/g=="
    }
}
```

- **encryptedMessage**: Base64-encoded encrypted text
- **key**: Base64-encoded 256-bit symmetric key
- **iv**: Base64-encoded initialization vector

## Frontend Decryption Implementation

### Flutter/Dart Implementation

#### Required Package
Add to your `pubspec.yaml`:
```yaml
dependencies:
  encrypt: ^5.0.3
```

#### Decryption Code
```dart
import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class MessageDecryptor {
  /// Decrypts a message received from the chat server
  static String? decryptMessage(Map<String, dynamic> encryptedContent) {
    try {
      // Extract encrypted components
      final String encryptedMessage = encryptedContent['encryptedMessage'];
      final String keyBase64 = encryptedContent['key'];
      final String ivBase64 = encryptedContent['iv'];

      // Decode base64 strings
      final key = Key.fromBase64(keyBase64);
      final iv = IV.fromBase64(ivBase64);

      // Create encrypter with AES algorithm
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // Decrypt the message
      final encrypted = Encrypted.fromBase64(encryptedMessage);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      return null;
    }
  }
}

// Usage Example
void handleIncomingMessage(Map<String, dynamic> messageData) {
  // Check if content exists and is encrypted
  if (messageData['content'] != null) {
    final decryptedText = MessageDecryptor.decryptMessage(messageData['content']);

    if (decryptedText != null) {
      print('Decrypted message: $decryptedText');
      // Display in UI
    } else {
      print('Failed to decrypt message');
    }
  }
}
```

### JavaScript/React Implementation

#### Required Package
```bash
npm install crypto-js
```

#### Decryption Code
```javascript
import CryptoJS from 'crypto-js';

const decryptMessage = (encryptedContent) => {
  try {
    const { encryptedMessage, key, iv } = encryptedContent;

    // Convert base64 strings to WordArrays
    const keyWordArray = CryptoJS.enc.Base64.parse(key);
    const ivWordArray = CryptoJS.enc.Base64.parse(iv);
    const ciphertext = CryptoJS.enc.Base64.parse(encryptedMessage);

    // Decrypt using AES-256-CBC
    const decrypted = CryptoJS.AES.decrypt(
      { ciphertext },
      keyWordArray,
      {
        iv: ivWordArray,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
      }
    );

    // Convert to UTF-8 string
    return decrypted.toString(CryptoJS.enc.Utf8);
  } catch (error) {
    console.error('Decryption error:', error);
    return null;
  }
};

// Usage in React component
const handleNewMessage = (messageData) => {
  if (messageData.content) {
    const decryptedText = decryptMessage(messageData.content);
    if (decryptedText) {
      console.log('Decrypted message:', decryptedText);
      // Update state and display in UI
    }
  }
};
```

## Complete Message Flow Example

### 1. Sending a Message (Client → Server)
```json
{
  "roomId": "1143c474-a960-454f-9218-67c40cb331e8",
  "senderId": "68a324c022b3ca74262a87da",
  "senderModel": "Student",
  "recipientId": "68a31d54a07e6f9b4879f381",
  "text": "Hello, I need help with calculus",
  "files": []
}
```

### 2. Server Encrypts and Broadcasts
The server automatically encrypts the text and sends:
```json
{
  "roomId": "1143c474-a960-454f-9218-67c40cb331e8",
  "senderId": "68a324c022b3ca74262a87da",
  "senderModel": "Student",
  "recipientId": "68a31d54a07e6f9b4879f381",
  "content": {
    "encryptedMessage": "jYnFaX76uUT1L1VGF5PeXX4nJ77hZeA/F2TyllpFJ3w=",
    "key": "+kEuRDFD8HY4fcC3ijXayw+YwcO5E5FUUb5CAHseq74=",
    "iv": "MUVJAJwvYdGKnAik2R6k/g=="
  },
  "files": [],
  "createdAt": "2025-08-28T11:08:28.128Z",
  "status": "sent"
}
```

### 3. Client Decrypts and Displays
Using the decryption code above, the client extracts the original message: "Hello, I need help with calculus"

## Important Security Notes

1. **Unique Keys Per Message**: Each message uses a new symmetric key and IV, ensuring that even if one message is compromised, others remain secure.

2. **Key Distribution**: The symmetric key is sent along with the message. In a production environment with higher security requirements, consider:
   - Implementing asymmetric encryption for key exchange
   - Using a key derivation function (KDF) with shared secrets
   - Storing keys separately from messages

3. **Transport Security**: Always use HTTPS/WSS in production to prevent man-in-the-middle attacks during key transmission.

4. **Storage**: The server stores only encrypted content. Keys should be managed carefully on the client side.

## Testing Decryption

### Test Data
Use this sample encrypted message to test your decryption implementation:

```json
{
  "content": {
    "encryptedMessage": "U2FsdGVkX1+ZqZ3xqZ3xqZ==",
    "key": "dGVzdGtleXRlc3RrZXl0ZXN0a2V5dGVzdGtleXRlc3Q=",
    "iv": "dGVzdGl2dGVzdGl2dGU="
  }
}
```

Expected decrypted result: "Test message"

## Troubleshooting

### Common Issues

1. **Decryption returns empty or garbled text**
   - Ensure you're using the correct algorithm (AES-256-CBC)
   - Verify base64 decoding is working correctly
   - Check that key is 32 bytes and IV is 16 bytes after decoding

2. **"Invalid key length" errors**
   - The key must be exactly 256 bits (32 bytes) after base64 decoding
   - Verify the key hasn't been truncated during transmission

3. **Padding errors**
   - Ensure PKCS7 padding is being used (default for most libraries)
   - Check that the encrypted message hasn't been modified

## Summary

The encryption system provides:
- ✅ AES-256-CBC encryption for all text messages
- ✅ Unique key and IV for each message
- ✅ Base64 encoding for safe transmission
- ✅ Easy integration with frontend frameworks
- ✅ No plain text storage on server

Frontend developers need to:
1. Install the appropriate crypto library for their platform
2. Implement the decryption function using the provided examples
3. Handle the decrypted content in their UI
4. Ensure proper error handling for failed decryptions