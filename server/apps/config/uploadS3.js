// const AWS = require("aws-sdk");
const multer = require("multer");
const multerS3 = require("multer-s3");
const { S3Client, DeleteObjectCommand } = require("@aws-sdk/client-s3");
const dotenv = require("dotenv");

dotenv.config();

// // Cấu hình AWS SDK
// AWS.config.update({
//   accessKeyId: process.env.BUCKET_ACCESS_KEY,
//   secretAccessKey: process.env.BUCKET_SECRET_ACCESS_KEY,
//   region: process.env.BUCKET_REGION,
// });

// Khởi tạo S3
let s3 = new S3Client({
  region: process.env.BUCKET_REGION,
  credentials: {
    accessKeyId: process.env.BUCKET_ACCESS_KEY,
    secretAccessKey: process.env.BUCKET_SECRET_ACCESS_KEY,
  },
  sslEnabled: false,
  s3ForcePathStyle: true,
  signatureVersion: "v4",
});

// Cấu hình Multer để lưu file vào S3
const upload = multer(
  {

  storage: multerS3({
    s3: s3,
    bucket: process.env.BUCKET_NAME,
    metadata: (req, file, cb) => {
      
      cb(null, { fieldName: file.fieldname });
    },
    key: (req, file, cb) => {
      const folder = req.body.Folder || "";
      cb(null, `${folder}/${Date.now().toString()}-${file.originalname}`);
    },
  }),
      
});

const deleteFileOnS3 = async (fileUrl) => {
  if (!fileUrl) {
    console.error("Không có URL file để xóa.");
    return;
  }

  try {
    const fileKey = fileUrl.split("/").slice(-2).join("/"); 
    console.log(`Đang xóa file trên S3 với key: ${fileKey}`);

    await s3.send(
      new DeleteObjectCommand({
        Bucket: process.env.BUCKET_NAME,
        Key: fileKey,
      })
    );

    console.log(`Đã xóa file thành công: ${fileKey}`);
  } catch (error) {
    console.error(`Lỗi khi xóa file trên S3: ${error.message}`);
    throw new Error("Lỗi khi xóa file trên S3.");
  }
};

module.exports = {
  upload,
  deleteFileOnS3,
};

