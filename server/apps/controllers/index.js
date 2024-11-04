var express = require("express");
var router = express.Router();
//cau hinh cho localhost:3000/home
router.use("/product", require(__dirname + "/productcontroller"));
router.use("/exercise", require(__dirname + "/ExerciseController"));
router.use("/user", require(__dirname + "/UserController"));
router.use("/workout", require(__dirname + "/WorkoutController"));
router.use("/progress", require(__dirname + "/ProgressController"));
router.use("/chalprogress", require(__dirname + "/ChalProgressController"));
router.use("/challenge", require(__dirname + "/ChallengeController"));
router.use("/history", require(__dirname + "/HistoryController"));
//duong dan admin
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
