var express = require("express");
var router = express.Router();
//cau hinh cho localhost:3000/home
router.use("/exercise", require(__dirname + "/ExerciseController"));
router.use("/user", require(__dirname + "/UserController"));
router.use("/workout", require(__dirname + "/WorkoutController"));
router.use("/progress", require(__dirname + "/ProgressController"));
router.use("/chalprogress", require(__dirname + "/ChalProgressController"));
router.use("/challenge", require(__dirname + "/ChallengeController"));
router.use("/history", require(__dirname + "/HistoryController"));
router.use("/post", require(__dirname + "/PostController"));
router.use("/like", require(__dirname + "/LikeController"));
router.use("/comment", require(__dirname + "/CommentController"));
router.use("/file", require(__dirname + "/UploadController"));
//duong dan admin
router.use("/admin/exercise", require(__dirname + "/admin/AdminExerciseController"));
router.use("/admin/user", require(__dirname + "/admin/AdminUserController"));
//router ma get khong co j phia sau thi la index
router.get("/", function (req, res) {
  // res.json({ message: "this is index page" });
  res.render("index.ejs");
});
router.get("/services", function (req, res) {
  // res.json({ message: "this is index page" });
  res.render("services.ejs");
});
module.exports = router;
