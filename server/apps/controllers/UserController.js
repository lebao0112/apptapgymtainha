var express = require("express");
var router = express.Router();
var UserService = require("./../services/UserService");
var User = require("./../entity/user");
const bcrypt = require("bcrypt");
const signToken = require("../middleware/generateToken");
const authenticateToken = require("../middleware/authMiddleware");
const jwt = require("jsonwebtoken");
router.post("/insert-user", async function (req, res) {
  const userService = new UserService();
  const user = new User();
  user.Name = req.body.Name;
  user.Email = req.body.Email;
  user.Password = req.body.Password; // Hash the password in production

  const result = await userService.insertUser(user);
  res.redirect("/user/user-list");
});
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

router.put("/update-username", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId; // Lấy userId từ token đã xác thực
    const { newName } = req.body; // Lấy tên mới từ request body

    if (!newName || newName.trim() === "") {
      return res.status(400).json({ message: "Tên không hợp lệ." });
    }

    const userService = new UserService();
    const result = await userService.updateUserName(userId, newName); // Gọi hàm update

    res.status(200).json({ message: "Tên người dùng đã được cập nhật." });
  } catch (error) {
    console.error("Error updating user name:", error);
    res.status(500).json({
      message: "Đã xảy ra lỗi khi cập nhật tên.",
      error: error.message,
    });
  }
});

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
