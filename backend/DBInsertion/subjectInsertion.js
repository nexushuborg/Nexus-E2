import mongoose from "mongoose";
import Subject from "../src/models/subject.model.js";
import dotenv from "dotenv";

dotenv.config();

async function insertSubjects() {
    await mongoose.connect();

    try {
        const subjects = [
            {
                subject_code: "CS101",
                subject_name: "Introduction to Computer Science",
            },
            {
                subject_code: "CS102",
                subject_name: "Programming Fundamentals",
            },
            {
                subject_code: "CS201",
                subject_name: "Data Structures and Algorithms",
            },
            {
                subject_code: "CS202",
                subject_name: "Object Oriented Programming",
            },
            {
                subject_code: "CS301",
                subject_name: "Database Management Systems",
            },
            {
                subject_code: "CS302",
                subject_name: "Computer Networks",
            },
            {
                subject_code: "CS401",
                subject_name: "Operating Systems",
            },
            {
                subject_code: "CS402",
                subject_name: "Software Engineering",
            },
            {
                subject_code: "MA101",
                subject_name: "Engineering Mathematics I",
            },
            {
                subject_code: "MA102",
                subject_name: "Engineering Mathematics II",
            },
            {
                subject_code: "PH101",
                subject_name: "Engineering Physics",
            },
            {
                subject_code: "CH101",
                subject_name: "Engineering Chemistry",
            },
        ];

        await Subject.insertMany(subjects);
        console.log("Subjects inserted successfully!");
        console.log(`${subjects.length} subjects have been added to the database.`);
    } catch (error) {
        console.error("Error inserting subjects:", error);
    } finally {
        await mongoose.disconnect();
    }
}

// Call the function
insertSubjects();
