// Function to generate a random 24-character hexadecimal MongoDB ObjectID
import Degree from "../src/models/degree.model.js";
import mongoose from "mongoose";
import Section from "../src/models/section.model.js";
function generateObjectId() {
  const chars = "0123456789abcdef";
  let result = "";
  for (let i = 0; i < 24; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return { $oid: result };
}

async function insert2027Sections() {
  await mongoose.connect(
    ""
  );

  try {
    const btech = await Degree.findOne({ short_name: "BTech" });
    if (!btech) {
      throw new Error("BTech degree not found.");
    }

    let sections = [];
    for (let i = "a".charCodeAt(0); i <= "z".charCodeAt(0); i++) {
      const letter = String.fromCharCode(i).toUpperCase();
      console.log(letter);
      for (let i = 1; i <= 4; i++) {
        for (let j = 1; j <= 4; j++) {
          const section = {
            section_name: `2341${i}${letter}${j}`,
            batch: 2027,
            degree: btech._id,
            faculty: [],
            students: [],
          };
          sections.push(section);
        }
      }
    }
    // console.log(sections.length);
    await Section.insertMany(sections);
    console.log("Sections inserted successfully!");
  } catch (error) {
    console.error("Error inserting sections:", error);
  } finally {
    await mongoose.disconnect();
  }
}

// Call the function
// insert2027Sections();


async function insert2028Section(params) {
  await mongoose.connect(
    ""
  );

  try {
    const btech = await Degree.findOne({ short_name: "BTech" });
    if (!btech) {
      throw new Error("BTech degree not found.");
    }
    let sections = [];
    for (let i = "a".charCodeAt(0); i <= "z".charCodeAt(0); i++) {
      const letter = String.fromCharCode(i).toUpperCase();
       for(let i = 1; i <= 4; i++) {

        const section = {
            section_name:`24E1${letter}${i}`,
            batch: 2028,
            degree: btech._id,
            faculty: [],
            students: [],
          };

        sections.push(section);

       }

    }

    await Section.insertMany(sections);

  } catch (error) {
    console.log("Error inserting sections:", error);
  }
  finally {
    await mongoose.disconnect();
  }
}

// Call the function
 insert2028Section();