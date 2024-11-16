var express = require("express");
var router = express.Router();
var UserService = require("./../../services/UserService");
var User = require("./../../entity/user");
const bcrypt = require("bcrypt");
const signToken = require("../../middleware/generateToken");
const authenticateToken = require("../../middleware/authMiddleware");
const jwt = require("jsonwebtoken");
const authorizeRole = require("../../middleware/authorizeRole");

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

    if (user.Role != "admin") {
      return res.status(403).json({ message: "Access denied!" });
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

module.exports = router;