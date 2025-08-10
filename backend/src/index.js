import app from "./app.js";
import dotenv from "dotenv";
dotenv.config();



const PORT = process.env.PORT || 3000;

app.listen(PORT, async ()=> {

    //start your database connection here if needed
    console.log(`Server is running on port ${PORT}`);
})