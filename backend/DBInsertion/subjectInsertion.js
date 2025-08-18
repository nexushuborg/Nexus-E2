import mongoose from "mongoose";
import Subject from "../src/models/subject.model.js";
import dotenv from "dotenv";

dotenv.config();

async function insertSubjects() {
    await mongoose.connect("");

    try {
        const subjects = [
            { subject_code: "CSE1002", subject_name: "Discrete Mathematics", short_name: "DM" },
            { subject_code: "MTH1101", subject_name: "Calculus A", short_name: "Calc-A" },
            { subject_code: "CSE1001", subject_name: "Introduction to Computer Programming", short_name: "ICP" },
            { subject_code: "PHY1001", subject_name: "University Physics: Mechanics", short_name: "UPM" },
            { subject_code: "HSS1972", subject_name: "Universal Human Values", short_name: "UHV" },

            { subject_code: "CSE2001", subject_name: "Data Structures and Algorithms", short_name: "DSA" },
            { subject_code: "CSE1004", subject_name: "Introduction to Graph Theory", short_name: "IGT" },
            { subject_code: "MTH2001", subject_name: "Calculus B", short_name: "Calc-B" },
            { subject_code: "PHY2001", subject_name: "University Physics: Electricity and Magnetism", short_name: "UPEM" },
            { subject_code: "HSS1021", subject_name: "Principles of Microeconomics", short_name: "PM" },

            { subject_code: "CSE2141", subject_name: "Computer Science Workshop 1", short_name: "CSW1" },
            { subject_code: "EET1211", subject_name: "Digital Logic Design", short_name: "DLD" },
            { subject_code: "CSE3131", subject_name: "Algorithms Design 1", short_name: "AD1" },
            { subject_code: "MTH2002", subject_name: "Probability and Statistics", short_name: "PS" },
            { subject_code: "HSS2021", subject_name: "Principle of Macroeconomics", short_name: "PM" },

            { subject_code: "CSE3141", subject_name: "Computer Science Workshop 2", short_name: "CSW2" },
            { subject_code: "EET2211", subject_name: "Computer Organisation and Architecture", short_name: "COA" },
            { subject_code: "CSE4131", subject_name: "Algorithm Design 2", short_name: "AD2" },
            { subject_code: "MTH3003", subject_name: "Applied Linear Algebra", short_name: "ALA" },
            { subject_code: "GEN1972", subject_name: "Universal Human Values", short_name: "UHV" },

            { subject_code: "CSE3544", subject_name: "Practical Programming with C", short_name: "PPC" },
            { subject_code: "CSE3249", subject_name: "Design Principles of Operating System", short_name: "DPOS" },
            { subject_code: "CSE3751", subject_name: "Computer Networking: Concepts", short_name: "CNC" },
            { subject_code: "CSE3651", subject_name: "Python for Computer Science and Data Science 1", short_name: "PCS & DS 1" },
            { subject_code: "CSE3731", subject_name: "Introduction to Theory of Computation", short_name: "ITC" },
            { subject_code: "CSE3787", subject_name: "Essential Mathematics for Artificial Intelligence 1", short_name: "EMAI" },

            { subject_code: "CSE3545", subject_name: "Game Programming with C++", short_name: "GPC" },
            { subject_code: "CSE3151", subject_name: "Introduction to Database", short_name: "ID" },
            { subject_code: "CSE3752", subject_name: "Computer Networking: Security", short_name: "CNS" },
            { subject_code: "CSE3652", subject_name: "Python for Computer Science and Data Science 2", short_name: "PCS & DS 2" },
            { subject_code: "CSE3739", subject_name: "Compilers: Principles, Techniques and Tools", short_name: "CPTT" },
            { subject_code: "CSE3788", subject_name: "Essential Mathematics for Artificial Intelligence 2", short_name: "EMAI 2" },
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
