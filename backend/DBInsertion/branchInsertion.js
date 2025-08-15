import mongoose from "mongoose";
import Degree from "../src/models/degree.model.js";
import Branch from "../src/models/branch.model.js";
import dotenv from "dotenv";

dotenv.config();

async function insertBranches() {
  await mongoose.connect(); 
  try {
    const btech = await Degree.findOne({ short_name: "BTech" });
    if (!btech) {
      throw new Error("BTech degree not found.");
    }

    const branches = [
      {
        name: "Computer Science and Engineering",
        short_name: "CSE",
        degree: btech._id,
      },
      {
        name: "Electronics and Communication Engineering",
        short_name: "ECE",
        degree: btech._id,
      },
      {
        name: "Mechanical Engineering",
        short_name: "ME",
        degree: btech._id,
      },
    ];

    await Branch.insertMany(branches);
    console.log("Branches inserted successfully!");
  } catch (err) {
    console.error("Error inserting branches:", err);
  } finally {
    await mongoose.disconnect();
  }
}

insertBranches();



