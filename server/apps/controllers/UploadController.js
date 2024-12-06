const express = require("express");
const {upload} = require("../config/uploadS3"); 
const router = express.Router();

// Route xử lý upload file
router.post("/upload", upload.single("file"), (req, res) => {
  try {
    // req.file chứa thông tin về file đã upload
    const file = req.file;

    res.status(200).json({
      message: "File uploaded successfully!",
      fileUrl: file.location, // Đường dẫn file trên S3
    });
  } catch (error) {
    console.error("Error uploading file:", error);
    res.status(500).json({
      message: "Error uploading file",
      error: error.message,
    });
  }
});

module.exports = router;
