import TelegramBot from "node-telegram-bot-api";



const BOT_TOKEN = process.env.BOT_TOKEN;
if (!BOT_TOKEN) {
  throw new Error("BOT_TOKEN is not defined in the environment variables.");
}
export const bot = new TelegramBot(BOT_TOKEN, { polling: false });
