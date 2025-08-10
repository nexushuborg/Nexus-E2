import dotenv from "dotenv"
dotenv.config();
import mongoose from 'mongoose'

const connectToDb = () => {
    mongoose.connect(process.env.MONGO_URI)
        .then(() => console.log('Connected to MongoDB'))
        .catch(err => console.log(err))
}

export default connectToDb;