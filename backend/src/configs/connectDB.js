import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config();


// Create a connection object to store our database connections
const connection = {
    main: null,
    chat: null,
    isInitialized: false
};


export const connectDB = async () => {
    try {
        // If already initialized, just return the existing connection
        if (connection.isInitialized) {
            console.log("DB connections already initialized, reusing existing connections");
            return connection;
        }

        const MAIN_URI = process.env.MONOGO_MAINDB_URI;
        const CHAT_URI = process.env.MONOGO_CHATDB_URI;

        if(!MAIN_URI){
            throw new Error("MONOGO_MAINDB_URI is not defined in the environment variables.");
        }
        if(!CHAT_URI){
            throw new Error("MONOGO_CHATDB_URI is not defined in the environment variables.");
        }

        // Create main database connection
        connection.main = await mongoose.createConnection(MAIN_URI);
        connection.main.on("connected", () => {
            console.log("MongoDB Main Database connected successfully")
        });

        // Create chat database connection
        connection.chat = await mongoose.createConnection(CHAT_URI);
        connection.chat.on("connected", () => {
            console.log("MongoDB Chat Database connected successfully")
        });

        // Handle errors for main connection
        connection.main.on("error", (err) => {
            console.log("MongoDB Main Database connection error: ", err)
        });

        // Handle errors for chat connection
        connection.chat.on("error", (err) => {
            console.log("MongoDB Chat Database connection error: ", err)
        });

        // Mark as initialized
        connection.isInitialized = true;

        return connection;
    } catch (error) {
        console.log("Error in DB connection", error);
        process.exit(1);
    }
}

export default connection;