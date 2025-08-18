import Student from "../src/models/student.model.js";
import Section from "../src/models/section.model.js";
import Degree from "../src/models/degree.model.js";
import Branch from "../src/models/branch.model.js";
import mongoose from "mongoose";

// Function to generate random names
function generateRandomName() {
  const firstNames = [
    "Aarav", "Vivaan", "Aditya", "Vihaan", "Arjun", "Sai", "Reyansh", "Ayaan", "Krishna", "Ishaan",
    "Aadhya", "Ananya", "Diya", "Saanvi", "Aarohi", "Kavya", "Priya", "Ishika", "Riya", "Avni",
    "Rohan", "Nikhil", "Rahul", "Amit", "Vikram", "Suresh", "Rajesh", "Kiran", "Deepak", "Manish",
    "Sneha", "Pooja", "Meera", "Radha", "Sita", "Geeta", "Sunita", "Nisha", "Swati", "Preeti",
    "Aryan", "Dev", "Harsh", "Karan", "Yash", "Daksh", "Shivam", "Tanvi", "Kiara", "Myra",
    "Advik", "Kabir", "Shivansh", "Atharv", "Advaith", "Zara", "Aanya", "Shanaya", "Arya", "Navya"
  ];

  const lastNames = [
    "Sharma", "Patel", "Singh", "Kumar", "Gupta", "Agarwal", "Jain", "Bansal", "Garg", "Mittal",
    "Verma", "Yadav", "Saxena", "Mishra", "Tripathi", "Pandey", "Srivastava", "Tiwari", "Dubey", "Shukla",
    "Reddy", "Rao", "Nair", "Pillai", "Menon", "Iyer", "Bhat", "Kamath", "Shetty", "Hegde",
    "Das", "Roy", "Ghosh", "Mukherjee", "Chatterjee", "Banerjee", "Sengupta", "Bhattacharya", "Dutta", "Chakraborty",
    "Khanna", "Malhotra", "Kapoor", "Chopra", "Sethi", "Arora", "Bhatia", "Tandon", "Mehta", "Joshi",
    "Prasad", "Naidu", "Chandra", "Varma", "Sastry", "Raju", "Murthy", "Subramanian", "Krishnan", "Ramesh"
  ];

  const firstName = firstNames[Math.floor(Math.random() * firstNames.length)];
  const lastName = lastNames[Math.floor(Math.random() * lastNames.length)];
  return `${firstName} ${lastName}`;
}

// Function to generate random phone number
function generatePhoneNumber() {
  const prefixes = ["98", "99", "97", "96", "95", "94", "93", "92", "91", "90"];
  const prefix = prefixes[Math.floor(Math.random() * prefixes.length)];
  let number = prefix;
  for (let i = 0; i < 8; i++) {
    number += Math.floor(Math.random() * 10);
  }
  return number;
}

// Function to generate email from name
function generateEmail(fullName, regNo) {
  const namePart = fullName.toLowerCase().replace(/\s+/g, '.');
  return `${namePart}.${regNo.toLowerCase()}@gmail.com`;
}

// Function to generate registration number
function generateRegNo(batch, slno) {
  const year = batch.toString().slice(-2); // Get last 2 digits of batch year
  const paddedSlno = slno.toString().padStart(3, '0');
  return `${year}CS${paddedSlno}`;
}

async function create60Students() {
  await mongoose.connect(
    ""
  );

  try {
    // Get required references
    const btech = await Degree.findOne({ short_name: "BTech" });
    if (!btech) {
      throw new Error("BTech degree not found.");
    }

    // Assuming Computer Science branch exists - adjust as needed
    const csBranch = await Branch.findOne({ short_name: "CSE" });
    if (!csBranch) {
      throw new Error("CS branch not found.");
    }

    // Get available sections for batch 2027 - adjust batch as needed
    const section = await Section.findById("68a3187e0251e4b8448d6d76");

    const students = [];
    const usedPhoneNumbers = new Set();
    const usedEmails = new Set();

    for (let i = 1; i <= 60; i++) {
      const fullName = generateRandomName();
      const regNo = generateRegNo(2027, i);

      // Generate unique phone number
      let phoneNo;
      do {
        phoneNo = generatePhoneNumber();
      } while (usedPhoneNumbers.has(phoneNo));
      usedPhoneNumbers.add(phoneNo);

      // Generate unique email
      let email;
      do {
        email = generateEmail(fullName, regNo);
      } while (usedEmails.has(email));
      usedEmails.add(email);

      // Randomly assign gender
      const gender = Math.random() > 0.5 ? "male" : "female";
      const student = {
        full_name: fullName,
        password: "Student@123",
        reg_no: regNo,
        slno: i,
        is_cr: false, // You can randomly assign or set specific students as CR later
        email: email,
        section:section._id,
        phoneNo: phoneNo,
        isVerified: true,
        degree: btech._id,
        branch: csBranch._id,
        batch: 2027,
        currentYear: 1, // Assuming first year students
        gender: gender,
      };

      students.push(student);
    }

    // Create students one-by-one so studentSchema.pre('save') runs and hashes passwords
    const insertedStudents = [];
    for (const s of students) {
      const created = await Student.create(s);
      insertedStudents.push(created);
    }
    console.log(`${insertedStudents.length} students created successfully!`);

    // Update section strength and add students to sections
    for (const student of insertedStudents) {
      await Section.findByIdAndUpdate(
        student.section,
        {
          $push: { students: student._id },
          $inc: { strength: 1 }
        }
      );
    }

    console.log("Section strengths updated successfully!");

  } catch (error) {
    console.error("Error inserting students:", error);
  } finally {
    await mongoose.disconnect();
  }
}

// Call the function
create60Students();