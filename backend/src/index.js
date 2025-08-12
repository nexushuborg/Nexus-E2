import app from "./app.js";
import dotenv from "dotenv";
dotenv.config();
import {connectDB} from "./configs/connectDB.js"
import {redisClient} from "./configs/connectRedis.js"



const PORT = process.env.PORT || 3000;

app.listen(PORT, async ()=> {
    await connectDB() //This is good practice to ensure DB connection before starting the server
    await redisClient.on("ready",() => {
        console.log("✅ Redis is connected successfully");
    })
    console.log(`Server is running on port ${PORT}`);
})