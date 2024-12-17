var express = require("express");
var router = express.Router();
var ExerciseService = require("./../../services/ExerciseService");
var Exercise = require("./../../entity/exercise");
const authenticateToken = require("../../middleware/authMiddleware");
const authorizeRole = require("../../middleware/authorizeRole");

router.get("/exercise-list",authenticateToken, authorizeRole("admin"), async function (req, res) {
  const exerciseService = new ExerciseService();

  try {
    const exercises = await exerciseService.getExerciseList();
    res.json(exercises);
  } catch (error) {
    console.error("Error fetching exercise list:", error);
    res
      .status(500)
      .json({ message: "Failed to fetch exercise list", error: error.message });
  }
});
// Insert a new exercise
router.post("/insert-exercise", authenticateToken, authorizeRole("admin"), async function (req, res) {
  const exerciseService = new ExerciseService();
  const exercise = new Exercise();
  exercise.name = req.body.name;
  exercise.type = req.body.type;
  exercise.muscle = req.body.muscle;
  exercise.equipment = req.body.equipment;
  exercise.difficulty = req.body.difficulty;
  exercise.instructions = req.body.instructions;
  exercise.imageUrl = req.body.imageUrl;
  exercise.videoUrl = req.body.videoUrl;

  try {
    const result = await exerciseService.insertExercise(exercise);
    res.status(201).json({
      message: "Exercise added successfully",
      exerciseId: result.insertedId,
    });
  } catch (error) {
    console.error("Error adding exercise:", error);
    res
      .status(500)
      .json({ message: "Failed to add exercise", error: error.message });
  }
});

router.delete("/delete-exercise/:exerciseId", authenticateToken, authorizeRole("admin"), async function (req, res) {
  const exerciseService = new ExerciseService();
  const exerciseId = req.params.exerciseId;

  try {
    const exercise = await exerciseService.getExercise(exerciseId);
    if (!exercise) {
      return res.status(404).json({ message: "Exercise not found" });
    }

    await exerciseService.deleteExercise(exerciseId);
    res.status(200).json({ message: "Exercise deleted successfully" });
  } catch (error) {
    console.error("Error deleting exercise:", error);
    res
      .status(500)
      .json({ message: "Failed to delete exercise", error: error.message });
  }
});
module.exports = router;