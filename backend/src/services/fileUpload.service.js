import multer from 'multer';
import { uploadFile, getFileLink } from './chatService.js';

const storage = multer.memoryStorage();

const fileFilter = (req, file, cb) => {
    // Allow images, documents, and common file types
    const allowedMimeTypes = [
        'image/jpeg',
        'image/jpg',
        'image/png',
        'image/gif',
        'image/webp',
        'application/pdf',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'text/plain'
    ];

    if (allowedMimeTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        cb(new Error(`Unsupported file type: ${file.mimetype}`), false);
    }
};

export const uploadMiddleware = multer({
    storage: storage,
    fileFilter: fileFilter,
    limits: {
        fileSize: 10 * 1024 * 1024, // 10MB limit
        files: 3 // Maximum 3 files per request
    }
});

export const processAndUploadFiles = async (files) => {
    try {
        const uploadedFiles = [];
        
        for (const file of files) {
            // Validate file
            if (!file.buffer || !file.originalname || !file.mimetype) {
                throw new Error('Invalid file data');
            }

            const fileId = await uploadFile(file);
            const fileUrl = await getFileLink(fileId);
            
            uploadedFiles.push({
                fileId,
                url: fileUrl,
                name: file.originalname,
                mimeType: file.mimetype,
                size: file.size,
                uploadedAt: new Date().toISOString()
            });
        }
        
        return uploadedFiles;
    } catch (error) {
        console.error('File processing error:', error);
        throw new Error(`Failed to process files: ${error.message}`);
    }
};

export const validateFileSize = (file) => {
    const maxSize = 10 * 1024 * 1024; // 10MB
    if (file.size > maxSize) {
        throw new Error(`File ${file.originalname} is too large. Maximum size is 10MB.`);
    }
    return true;
};

export const getFileTypeIcon = (mimeType) => {
    if (mimeType.startsWith('image/')) return '🖼️';
    if (mimeType.includes('pdf')) return '📄';
    if (mimeType.includes('word')) return '📝';
    if (mimeType.includes('excel')) return '📊';
    if (mimeType.includes('text')) return '📄';
    return '📎';
};
