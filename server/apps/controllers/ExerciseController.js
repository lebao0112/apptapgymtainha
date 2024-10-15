var express = require("express");
var router = express.Router();
var ExerciseService = require("./../services/ExerciseService");
var Exercise = require("./../entity/exercise");

router.post("/insert-exercise", async function (req, res) {
  const exerciseService = new ExerciseService();
  const exercise = new Exercise();
  exercise.Name = req.body.Name;
  exercise.Description = req.body.Description;
  exercise.Category = req.body.Category;
  exercise.ImageUrl = req.body.ImageUrl;
  exercise.VideoUrl = req.body.VideoUrl;

  const result = await exerciseService.insertExercise(exercise);
  res.redirect("/exercise/exercise-list");
});

router.post("/update-exercise", async function (req, res) {
  const exerciseService = new ExerciseService();
  const exercise = new Exercise();
  exercise._id = req.body.Id;
  exercise.Name = req.body.Name;
  exercise.Description = req.body.Description;
  exercise.Category = req.body.Category;
  exercise.ImageUrl = req.body.ImageUrl;
  exercise.VideoUrl = req.body.VideoUrl;

  await exerciseService.updateExercise(exercise);
  res.redirect("/exercise/exercise-list");
});

router.post("/delete-exercise", async function (req, res) {
  const exerciseService = new ExerciseService();
  await exerciseService.deleteExercise(req.query.id);
  res.redirect("/exercise/exercise-list");
});

router.get("/exercise-list", async function (req, res) {
  const exerciseService = new ExerciseService();
  const exercises = await exerciseService.getExerciseList();
  res.render("exercise/exercise-list", { exercises });
});

module.exports = router;
