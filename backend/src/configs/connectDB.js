import dotenv from "dotenv";
dotenv.config();
import mongoose from "mongoose";

export const connectDB = async () => {
  try {
    const URI = process.env.MONGO_URI;
    if (!URI) {
      throw new Error("MONGO_URI is not defined in .env file");
    }
    const res = await mongoose.connect(URI);
    console.log(`MongoDB connected: ${res.connection.host}`);
  } catch (error) {
    console.log(`Error connecting to MongoDB: ${error.message}`);

    process.exit(1);
  }
};
