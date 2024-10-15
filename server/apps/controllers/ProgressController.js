var express = require("express");
var router = express.Router();
var ProgressService = require("./../services/ProgressService");
var Progress = require("./../entity/progress");

router.post("/insert-progress", async function (req, res) {
  const progressService = new ProgressService();
  const progress = new Progress();
  progress.UserId = req.body.UserId;
  progress.WorkoutId = req.body.WorkoutId;
  progress.ProgressPercentage = req.body.ProgressPercentage;
  progress.Completed = req.body.Completed;
  progress.CompletedAt = req.body.CompletedAt;

  const result = await progressService.insertProgress(progress);
  res.redirect("/progress/progress-list");
});

router.post("/update-progress", async function (req, res) {
  const progressService = new ProgressService();
  const progress = new Progress();
  progress._id = req.body.Id;
  progress.UserId = req.body.UserId;
  progress.WorkoutId = req.body.WorkoutId;
  progress.ProgressPercentage = req.body.ProgressPercentage;
  progress.Completed = req.body.Completed;
  progress.CompletedAt = req.body.CompletedAt;

  await progressService.updateProgress(progress);
  res.redirect("/progress/progress-list");
});

router.post("/delete-progress", async function (req, res) {
  const progressService = new ProgressService();
  await progressService.deleteProgress(req.query.id);
  res.redirect("/progress/progress-list");
});

router.get("/progress-list", async function (req, res) {
  const progressService = new ProgressService();
  const progresses = await progressService.getProgressList();
  res.render("progress/progress-list", { progresses });
});

module.exports = router;
