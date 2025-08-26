import crypto from 'crypto';

export const generateKeyPair = () => {
    const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
        modulusLength: 2048,
        publicKeyEncoding: {
            type: 'spki',
            format: 'pem'
        },
        privateKeyEncoding: {
            type: 'pkcs8',
            format: 'pem'
        }
    });
    return { publicKey, privateKey };
};

export const encryptMessage = async (message) => {
    try {
        if (!message) return null;

        // Generate a random symmetric key and IV
        const symmetricKey = crypto.randomBytes(32);
        const iv = crypto.randomBytes(16);

        // Encrypt the message with symmetric key
        const cipher = crypto.createCipheriv('aes-256-cbc', symmetricKey, iv);
        let encryptedMessage = cipher.update(message, 'utf8', 'base64');
        encryptedMessage += cipher.final('base64');

        // For simplicity in this example, we'll use the symmetric key directly
        // In a production environment, you'd want to use asymmetric encryption for key exchange
        return {
            encryptedMessage,
            key: symmetricKey.toString('base64'),
            iv: iv.toString('base64')
        };
    } catch (error) {
        console.error('Encryption failed:', error);
        return null;
    }
};

export const decryptMessage = async (encryptedData) => {
    try {
        if (!encryptedData) return null;

        const { encryptedMessage, key, iv } = encryptedData;

        // Decrypt the message using symmetric key
        const decipher = crypto.createDecipheriv(
            'aes-256-cbc',
            Buffer.from(key, 'base64'),
            Buffer.from(iv, 'base64')
        );
        let decryptedMessage = decipher.update(encryptedMessage, 'base64', 'utf8');
        decryptedMessage += decipher.final('utf8');

        return decryptedMessage;
    } catch (error) {
        console.error('Decryption failed:', error);
        return null;
    }
};
