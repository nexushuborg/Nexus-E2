import { app, httpServer } from "./app.js";
import dotenv from "dotenv";
dotenv.config();
import { connectDB } from "./configs/connectDB.js"
import { redisClient } from "./configs/connectRedis.js"
import { initializeModels } from "./utils/modelConnector.js";

const PORT = process.env.PORT || 3000;

// Initialize the database connections before starting the server
const startServer = async () => {
  try {
    // Connect to MongoDB first
    console.log("Connecting to MongoDB...");
    await connectDB();
    console.log("MongoDB connection successful");

    // Initialize all models after connection is established
    initializeModels();

    // Then connect to Redis
    console.log("Connecting to Redis...");
    await new Promise((resolve) => {
      redisClient.on("ready", () => {
        console.log("✅ Redis is connected successfully");
        resolve();
      });
    });

    // Start the server after connections are established
    httpServer.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
};

startServer();