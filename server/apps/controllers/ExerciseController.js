var express = require("express");
var router = express.Router();
var ExerciseService = require("./../services/ExerciseService");
var Exercise = require("./../entity/exercise");

// Insert a new exercise
router.post("/insert-exercise", async function (req, res) {
  const exerciseService = new ExerciseService();
  const exercise = new Exercise();
  exercise.name = req.body.name;
  exercise.type = req.body.type;
  exercise.muscle = req.body.muscle;
  exercise.equipment = req.body.equipment;
  exercise.difficulty = req.body.difficulty;
  exercise.instructions = req.body.instructions;

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

// Update an existing exercise
router.put("/update-exercise/:exerciseId", async function (req, res) {
  const exerciseService = new ExerciseService();
  const exerciseId = req.params.exerciseId;

  try {
    const exercise = await exerciseService.getExercise(exerciseId);
    if (!exercise) {
      return res.status(404).json({ message: "Exercise not found" });
    }

    // Update exercise details
    exercise.name = req.body.name || exercise.name;
    exercise.type = req.body.type || exercise.type;
    exercise.muscle = req.body.muscle || exercise.muscle;
    exercise.equipment = req.body.equipment || exercise.equipment;
    exercise.difficulty = req.body.difficulty || exercise.difficulty;
    exercise.instructions = req.body.instructions || exercise.instructions;

    await exerciseService.updateExercise(exercise);
    res.status(200).json({ message: "Exercise updated successfully" });
  } catch (error) {
    console.error("Error updating exercise:", error);
    res
      .status(500)
      .json({ message: "Failed to update exercise", error: error.message });
  }
});

// Get a list of all exercises
router.get("/exercise-list", async function (req, res) {
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

// Get a specific exercise by ID
router.get("/exercise/:exerciseId", async function (req, res) {
  const exerciseService = new ExerciseService();
  const exerciseId = req.params.exerciseId;

  try {
    const exercise = await exerciseService.getExercise(exerciseId);
    if (!exercise) {
      return res.status(404).json({ message: "Exercise not found" });
    }
    res.json(exercise);
  } catch (error) {
    console.error("Error fetching exercise:", error);
    res
      .status(500)
      .json({ message: "Failed to fetch exercise", error: error.message });
  }
});

module.exports = router;
