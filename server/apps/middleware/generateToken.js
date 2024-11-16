const jwt = require("jsonwebtoken");

const signToken = (req, res, next) => {
  const user = req.user;
  console.log("🚀 ~ signToken ~ user:", user);

  const token = jwt.sign(
    { userId: user._id, email: user.Email, role: user.Role },
    process.env.JWT_SECRET_KEY,
    { expiresIn: "30d" }
  );
    console.log("user token:",token);
  res.json({
    message: "Login successful",
    token: token,
    userId: user._id,
  });
};

module.exports = signToken;
