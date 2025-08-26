import { bot } from '../configs/connectTelegram.js';

export const uploadFile = async (file) => {
    try {
        const CHAT_ID = process.env.TELEGRAM_CHAT_ID;

        // Upload file to Telegram
        const telegramMessage = await bot.sendDocument(CHAT_ID, file.buffer, {
            filename: file.originalname,
            contentType: file.mimetype
        });

        return telegramMessage.document.file_id;
    } catch (error) {
        console.error('Error uploading file to Telegram:', error);
        throw error;
    }
};

export const getFileLink = async (fileId) => {
    try {
        const file = await bot.getFile(fileId);
        const filePath = file.file_path;
        return `https://api.telegram.org/file/bot${process.env.BOT_TOKEN}/${filePath}`;
    } catch (error) {
        console.error('Error getting file link:', error);
        return null;
    }
};
