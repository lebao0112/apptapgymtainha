var express = require("express");
var router = express.Router();
var UserService = require("./../services/UserService");
var User = require("./../entity/user");
const bcrypt = require("bcrypt");
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

// Login user
router.post("/login", async function (req, res) {
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

  // If login is successful
  res.json({ message: "Login successful", userId: user._id });
});
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

module.exports = router;
