import multer from "multer"
import path from "path";

const allowedTypes = [
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "text/plain",
  "application/vnd.ms-powerpoint",
  "application/vnd.openxmlformats-officedocument.presentationml.presentation",
  "image/jpeg",
  "image/png",
  "image/jpg"
];


const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "./public/temp")
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
    cb(null, file.fieldname + '-' + uniqueSuffix)
  }
})

export const upload = multer({ storage })

const telegramStorage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "./public/telegram");
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  },
})



function fileFilter(req, file, cb) {
  // Log for debugging (optional)
  console.log("Uploaded file MIME type:", file.mimetype);
  console.log("Original filename:", file.originalname);

  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true); // Accept file
  } else {
    // Create a readable list of allowed types
    const allowedTypesReadable = [
      "PDF (.pdf)",
      "Word Document (.doc, .docx)",
      "Plain Text (.txt)",
      "PowerPoint (.ppt, .pptx)",
      "JPEG, PNG, JPG (images)"
    ];

    cb(
      new Error(
        `Unsupported file type: ${file.mimetype}` +"|"+`Allowed types are: ${allowedTypesReadable.join(", ")}.`
      ),
      false // Reject file
    );
  }
}


// Final multer setup
export const telegramUpload = multer({
  storage:telegramStorage,
  fileFilter,
  limits: { fileSize: 20 * 1024 * 1024 },// 20 MB limit
});