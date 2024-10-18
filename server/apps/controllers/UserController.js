var express = require("express");
var router = express.Router();
var UserService = require("./../services/UserService");
var User = require("./../entity/user");
const bcrypt = require("bcrypt");
const signToken = require("../middleware/generateToken");
const authenticateToken = require("../middleware/authMiddleware");

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
    // Hash the password for security
    const hashedPassword = await bcrypt.hash(req.body.Password, 10);
    user.Name = req.body.Name;
    user.Email = req.body.Email;
    user.Password = hashedPassword;
    user.Height = req.body.Height; // Add height from the request
    user.Weight = req.body.Weight; // Add weight from the request

    // Insert the user into the database
    const result = await userService.insertUser(user);
    console.log("User registered successfully:", result);

    res.status(201).json({
      message: "User registered successfully",
      userId: result.insertedId,
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

// router.post("/login", async function (req, res) {
//   const userService = new UserService();
//   const user = await userService.getUserByEmail(req.body.Email);

//   if (!user) {
//     return res.status(400).json({ message: "User not found" });
//   }

//   const isPasswordValid = await bcrypt.compare(
//     req.body.Password,
//     user.Password
//   );
//   if (!isPasswordValid) {
//     return res.status(400).json({ message: "Invalid password" });
//   }

//   const token = jwt.sign({ userId: user._id }, secretKey, { expiresIn: "7d" });

//   res.json({ message: "Login successful", userId: user._id, token });
// });

// router.post("/login", async function (req, res) {
//   const userService = new UserService();
//   const user = await userService.getUserByEmail(req.body.Email);

//   if (!user) {
//     return res.status(400).json({ message: "User not found" });
//   }

//   const isPasswordValid = await bcrypt.compare(
//     req.body.Password,
//     user.Password
//   );
//   if (!isPasswordValid) {
//     return res.status(400).json({ message: "Invalid password" });
//   }

//   res.json({ message: "Login successful", userId: user._id });
// });
router.post("/update-user", async function (req, res) {
  const userService = new UserService();
  const user = new User();
  user._id = req.body.Id;
  user.Name = req.body.Name;
  user.Email = req.body.Email;

  await userService.updateUser(user);
  res.redirect("/user/user-list");
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
