var express = require("express");
var router = express.Router();
var WorkoutService = require("./../services/WorkoutService");
var Workout = require("./../entity/workout");
var ExerciseService = require("./../services/ExerciseService");
const authenticateToken = require("../middleware/authMiddleware");

// Route để thêm workout, yêu cầu xác thực JWT
router.post("/insert-workout", authenticateToken, async function (req, res) {
  const workoutService = new WorkoutService();
  const workout = new Workout();
  workout.Title = req.body.Title;
  workout.Description = req.body.Description;
  workout.Exercises = req.body.Exercises; // Array of exercise IDs
  workout.UserId = req.user.userId; // Lấy userId từ token đã xác thực

  try {
    const result = await workoutService.insertWorkout(workout);
    res.status(201).json({
      message: "Workout added successfully",
      workoutId: result.insertedId,
    });
  } catch (error) {
    console.error("Error adding workout:", error);
    res.status(500).json({
      message: "Failed to add workout",
      error: error.message,
    });
  }
});

// Route để cập nhật workout, yêu cầu xác thực JWT
router.put("/update-workout/:workoutId", authenticateToken, async function (req, res) {
  const workoutService = new WorkoutService();
  const workoutId = req.params.workoutId;

  try {
    const workout = await workoutService.getWorkout(workoutId);
    if (!workout || workout.UserId !== req.user.userId) {
      return res
        .status(404)
        .json({ message: "Workout not found or not owned by user" });
    }

    // Cập nhật thông tin workout
    workout.Title = req.body.Title || workout.Title;
    workout.Description = req.body.Description || workout.Description;
    workout.Exercises = req.body.Exercises || workout.Exercises;

    await workoutService.updateWorkout(workout);
    res.status(200).json({ message: "Workout updated successfully" });
  } catch (error) {
    console.error("Error updating workout:", error);
    res
      .status(500)
      .json({ message: "Failed to update workout", error: error.message });
  }
});

// Route để xóa workout, yêu cầu xác thực JWT
router.delete("/delete-workout/:workoutId", authenticateToken, async function (req, res) {
  const workoutService = new WorkoutService();
  const workoutId = req.params.workoutId;

  try {
    const workout = await workoutService.getWorkout(workoutId);
    if (!workout || workout.UserId !== req.user.userId) {
      return res
        .status(404)
        .json({ message: "Workout not found or not owned by user" });
    }

    await workoutService.deleteWorkout(workoutId);
    res.status(200).json({ message: "Workout deleted successfully" });
  } catch (error) {
    console.error("Error deleting workout:", error);
    res
      .status(500)
      .json({ message: "Failed to delete workout", error: error.message });
  }
});

// Lấy danh sách các workout của người dùng (đã xác thực)
router.get("/user-workouts", authenticateToken, async function (req, res) {
  const workoutService = new WorkoutService();
  const userId = req.user.userId; // Lấy userId từ token

  try {
    console.log("Fetching workouts for user:", userId);
    const workouts = await workoutService.getWorkoutsByUserId(userId);
    console.log("Workouts found:", workouts);

    res.json(workouts); // Trả về danh sách workouts của người dùng
  } catch (error) {
    console.error("Error fetching workouts for user:", error);
    res
      .status(500)
      .json({ message: "Failed to fetch workouts", error: error.message });
  }
});

// Route để lấy toàn bộ workout (có thể không cần xác thực tùy theo yêu cầu)
router.get("/workout-list", async function (req, res) {
  const workoutService = new WorkoutService();
  const workouts = await workoutService.getWorkoutList();
  res.render("workout/workout-list", { workouts });
});
// Route để lấy chi tiết workout dựa vào workoutId
router.get("/workout/:workoutId", authenticateToken, async function (req, res) {
  const workoutService = new WorkoutService();
  const exerciseService = new ExerciseService();
  const workoutId = req.params.workoutId;

  try {
    // Fetch the workout by ID
    const workout = await workoutService.getWorkout(workoutId);

    // Check if the workout exists and belongs to the authenticated user
    if (!workout || workout.UserId !== req.user.userId) {
      return res.status(404).json({ message: "Workout not found or not owned by user" });
    }

    // Fetch the full exercise details for each exercise in the workout
    const exerciseDetails = await Promise.all(
      workout.Exercises.map(exerciseId => exerciseService.getExercise(exerciseId))
    );

    // Return the workout details including exercise details
    res.status(200).json({
      ...workout,
      Exercises: exerciseDetails  // Replace exercise IDs with full exercise details
    });
  } catch (error) {
    console.error("Error fetching workout:", error);
    res.status(500).json({ message: "Failed to fetch workout", error: error.message });
  }
});
module.exports = router;
