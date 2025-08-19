import TelegramBot from "node-telegram-bot-api";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";

// const __filename = fileURLToPath(import.meta.url);
// const __dirname = path.dirname(__filename);

// Configure dotenv to look for .env file in the backend root directory
// dotenv.config({ path: path.join(__dirname, '../../.env') });

const BOT_TOKEN = process.env.BOT_TOKEN;
console.log('BOT_TOKEN:', process.env.BOT_TOKEN);
if (!BOT_TOKEN) {
  throw new Error("BOT_TOKEN is not defined in the environment variables.");
}
export const bot = new TelegramBot(BOT_TOKEN, { polling: false }); // Set polling to false for production use, or true for development/testing

/*
what is polling in telegram bot?
Polling in Telegram Bot API refers to the method of continuously checking for new messages or updates from the Telegram servers. When a bot is set to "polling" mode, it repeatedly sends requests to the Telegram servers to fetch any new messages or updates that have been sent to the bot. This allows the bot to respond to user interactions in real-time.
Polling is useful for development and testing, but in production, it's often recommended to use webhooks
*/

// const CHAT_ID = process.env.CHAT_ID;

// // const sent =await bot.sendMessage(CHAT_ID, "✅ Bot storage is ready!");

// // if (!sent) {
// //   throw new Error("Failed to send message to the Telegram chat.");
// // }

// //deleting the message after sending
// await bot.deleteMessage(CHAT_ID, 5);
// console.log(sent)