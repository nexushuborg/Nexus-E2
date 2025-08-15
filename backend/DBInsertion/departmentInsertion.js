import mongoose from "mongoose";
import Department from "../src/models/department.model.js";
import dotenv from "dotenv";

dotenv.config();

async function insertDepartments() {
    await mongoose.connect();

    try {
        const departments = [
            {
                name: "Computer Science and Engineering",
                short_name: "CSE",
            },
            {
                name: "Electronics and Communication Engineering",
                short_name: "ECE",
            },
            {
                name: "Mechanical Engineering",
                short_name: "ME",
            },
            {
                name: "Electrical Engineering",
                short_name: "EE",
            },
            {
                name: "Civil Engineering",
                short_name: "CE",
            },
            {
                name: "Information Technology",
                short_name: "IT",
            },
            {
                name: "Chemical Engineering",
                short_name: "CHE",
            },
            {
                name: "Aerospace Engineering",
                short_name: "AE",
            },
            {
                name: "Biotechnology",
                short_name: "BT",
            },
            {
                name: "Materials Science and Engineering",
                short_name: "MSE",
            },
            {
                name: "Industrial Engineering",
                short_name: "IE",
            },
            {
                name: "Environmental Engineering",
                short_name: "ENV",
            },
            {
                name: "Mathematics",
                short_name: "MATH",
            },
            {
                name: "Physics",
                short_name: "PHY",
            },
            {
                name: "Chemistry",
                short_name: "CHEM",
            },
            {
                name: "English",
                short_name: "ENG",
            },
            {
                name: "Management Studies",
                short_name: "MS",
            },
        ];

        await Department.insertMany(departments);
        console.log("Departments inserted successfully!");
        console.log(`${departments.length} departments have been added to the database.`);
    } catch (error) {
        console.error("Error inserting departments:", error);
    } finally {
        await mongoose.disconnect();
    }
}

// Call the function
insertDepartments();
