var express = require("express");
var router = express.Router();
var UserService = require("./../services/UserService");
var User = require("./../entity/user");
const bcrypt = require("bcrypt");
const signToken = require("../middleware/generateToken");
const authenticateToken = require("../middleware/authMiddleware");
const jwt = require("jsonwebtoken");
const  {upload, deleteFileOnS3} = require("../config/uploadS3");



// Register user
router.post("/register", async function (req, res) {
  const userService = new UserService();
  const user = new User();

  try {
    // Kiểm tra email đã tồn tại chưa
    const existingUser = await userService.getUserByEmail(req.body.Email);
    if (existingUser) {
      return res.status(400).json({
        message: "Email đã tồn tại, vui lòng chọn email khác.",
      });
    }
    const hashedPassword = await bcrypt.hash(req.body.Password, 10);
    user.Name = req.body.Name;
    user.Email = req.body.Email;
    user.Password = hashedPassword;
    user.Height = req.body.Height;
    user.Weight = req.body.Weight;
    user.DateOfBirth = req.body.DateOfBirth;
    user.Gender = req.body.Gender;
    user.AvatarUrl = "";
    user.Role = "user";
    const result = await userService.insertUser(user);
    console.log("User registered successfully:", result);

    res.status(201).json({
      message: "User registered successfully",
      user: user,
    });
  } catch (error) {
    console.error("Error registering user:", error);
    res
      .status(500)
      .json({ message: "User registration failed", error: error.message });
  }
});

router.post(
  "/login",
  async function (req, res, next) {
    const userService = new UserService();
    const user = await userService.getUserByEmail(req.body.Email);

    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    const isPasswordValid = await bcrypt.compare(
      req.body.Password,
      user.Password
    );

    if (!isPasswordValid) {
      return res.status(400).json({ message: "Invalid password" });
    }

    req.user = user; // Đặt thông tin người dùng vào req để middleware sử dụng
    next(); // Chuyển tiếp đến middleware signToken
  },
  signToken
);

router.post(
  "/google-login",
  async function (req, res, next) {
    console.log("Request Body:", req.body); // Debug log
    const { Email, Name, googleId } = req.body;

    const userService = new UserService();
    let user = await userService.getUserByEmail(Email);

    if (!user) {
      user = new User();
      user.Name = Name;
      user.Email = Email;
      user.Password = googleId;
      user.Height = 0;
      user.Weight = 0;
      user.AvatarUrl = null;
      user.DateOfBirth = "2024-10-20 00:00:00.000";
      user.Gender = "male";
      user.Role = "user";
      // Save new user in MongoDB
      const result = await userService.insertUser(user);
      user._id = result.insertedId; // Set the `_id` from the MongoDB result
    }

    // Create JWT token for the existing or newly created user
    //  const token = jwt.sign(
    //    { userId: user._id, email: user.Email },
    //    process.env.JWT_SECRET_KEY,
    //    { expiresIn: "30d" }
    //  );

    req.user = user; // Đặt thông tin người dùng vào req để middleware sử dụng
    next(); //

    //  res.json({
    //    message: "Google login successful",
    //    token: token,
    //    userId: user._id,
    //  });
  },
  signToken
);

router.put(
  "/update-profile",
  authenticateToken,
  upload.single("avatar"),
  async (req, res) => {
    try {
      // Lấy userId từ token
      const userId = req.user.userId;

      // Lấy các trường từ body
      const { name, email, height, weight, gender, dateOfBirth } = req.body;

      const updatedFields = {};

      // Chỉ thêm các trường hợp lệ vào `updatedFields` (bỏ qua các trường có giá trị "")
      if (name && name.trim() !== "") updatedFields.Name = name;
      if (email && email.trim() !== "") updatedFields.Email = email;
      if (height && height.trim() !== "")
        updatedFields.Height = parseFloat(height);
      if (weight && weight.trim() !== "")
        updatedFields.Weight = parseFloat(weight);
      if (gender && gender.trim() !== "") updatedFields.Gender = gender;
      if (dateOfBirth && dateOfBirth.trim() !== "")
        updatedFields.DateOfBirth = dateOfBirth;

      
      // Xử lý avatar nếu có file được tải lên
      if (req.file && req.file.location) {
        // Lấy thông tin người dùng hiện tại
        const userService = new UserService();
        const currentUser = await userService.getUser(userId);

        if (!currentUser) {
          return res.status(404).json({
            message: "Không tìm thấy người dùng",
          });
        }

        // Xóa ảnh cũ khỏi S3 (nếu tồn tại)
        const oldAvatarUrl = currentUser.AvatarUrl;
        if (oldAvatarUrl) {
          await deleteFileOnS3(oldAvatarUrl);
        }

        // Cập nhật URL ảnh mới
        updatedFields.AvatarUrl = req.file.location;
      }

      // Cập nhật thông tin người dùng
      const userService = new UserService();
      const updatedUser = await userService.updateUser(userId, updatedFields);

      if (!updatedUser) {
        console.log("flag");
        return res.status(404).json({
          message: "Không tìm thấy người dùng",
        });
      }

      // Trả về phản hồi thành công
      return res.status(200).json({
        message: "Cập nhật thông tin người dùng thành công",
        user: updatedUser,
      });
    } catch (error) {
      console.error("Error updating profile:", error);
      return res.status(500).json({
        message: "Đã xảy ra lỗi khi cập nhật thông tin người dùng",
        error: error.message,
      });
    }
  }
);


router.post("/delete-user", async function (req, res) {
  const userService = new UserService();
  await userService.deleteUser(req.query.id);
  res.redirect("/user/user-list");
});

router.get("/user-list", async function (req, res) {
  const userService = new UserService();
  const users = await userService.getUserList();
  res.json(users);
  //   res.render("user/user-list", { users });
});

router.get("/profile", authenticateToken, async (req, res) => {
  try {
    // Lấy userId từ token đã xác thực
    const userId = req.user.userId;
    const userService = new UserService();
    // Gọi service để lấy thông tin người dùng
    const user = await userService.getUser(userId);
    console.log("🚀 ~ router.get ~ user:", user);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Trả về thông tin người dùng
    res.json({
      user,
      // userName: user.Name,
      // email: user.Email,
    });
  } catch (error) {
    res.status(500).json({
      message: "Failed to retrieve user profile",
      error: error.message,
    });
  }
});


router.get("/someone-profile/:id", authenticateToken, async (req, res) => {
  try {
    const userService = new UserService();
    // Gọi service để lấy thông tin người dùng
    const user = await userService.getUser(req.params.id);
    console.log("🚀 ~ router.get ~ user:", user);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Trả về thông tin người dùng
    res.json({
      userProfile: user,
      // userName: user.Name,
      // email: user.Email,
    });
  } catch (error) {
    res.status(500).json({
      message: "Failed to retrieve user profile",
      error: error.message,
    });
  }
});

module.exports = router;
