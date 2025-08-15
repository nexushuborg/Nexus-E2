import express from "express";
import helmet from "helmet";
import {rateLimit} from "express-rate-limit";
import cookieParser from "cookie-parser";
import cors from "cors";
import morgan from "morgan";
import dotenv from "dotenv";
dotenv.config();


const app = express();

//Security middleware
app.use(helmet(
    {
        contentSecurityPolicy:false
    }
))

app.use(cors());
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded(
    {
        extended: true  
    }
))

//Rate Limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    limit: 100, // Limit each IP to 100 requests per window
    message: {
        success: false,
        message: "Too many requests, please try again later."
    },
    standardHeaders: true,
    legacyHeaders: false,
})
app.use(limiter);

//Logging Middlware
app.use(morgan("dev"));

//routes 
import studentRoutes from "./routes/student/user.route.js"
import teacherRoutes from "./routes/teacher/user.route.js"

app.use("/api/v1/student",studentRoutes);
app.use("/api/v1/teacher",teacherRoutes);



app.get("/",(req,res) => {
    res.status(200).json({
        success: true,
        message: "Welcome to Nexus E2 Backend"
    })
})

export default app;