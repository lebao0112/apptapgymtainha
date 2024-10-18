var express = require("express");
var router = express.Router();
var WorkoutService = require("./../services/WorkoutService");
var Workout = require("./../entity/workout");
const authenticateToken = require("../middleware/authMiddleware");

router.post("/insert-workout", async function (req, res) {
  const workoutService = new WorkoutService();
  const workout = new Workout();
  workout.Title = req.body.Title;
  workout.Description = req.body.Description;
  workout.Exercises = req.body.Exercises; // Array of exercise IDs

  const result = await workoutService.insertWorkout(workout);
  res.redirect("/workout/workout-list");
});

router.post("/update-workout", async function (req, res) {
  const workoutService = new WorkoutService();
  const workout = new Workout();
  workout._id = req.body.Id;
  workout.Title = req.body.Title;
  workout.Description = req.body.Description;
  workout.Exercises = req.body.Exercises; // Array of updated exercise IDs

  await workoutService.updateWorkout(workout);
  res.redirect("/workout/workout-list");
});

router.post("/delete-workout", async function (req, res) {
  const workoutService = new WorkoutService();
  await workoutService.deleteWorkout(req.query.id);
  res.redirect("/workout/workout-list");
});

router.get("/workout-list", async function (req, res) {
  const workoutService = new WorkoutService();
  const workouts = await workoutService.getWorkoutList();
  res.render("workout/workout-list", { workouts });
});

router.get("/user-workouts", authenticateToken, async function (req, res) {
  const workoutService = new WorkoutService();
  const userId = req.user.userId; // Lấy userId từ token

  try {
    console.log("Fetching workouts for user:", userId); // In ra userId để kiểm tra
    const workouts = await workoutService.getWorkoutsByUserId(userId);
    console.log("Workouts found:", workouts); // In ra workouts tìm thấy

    res.json(workouts); // Trả về danh sách workouts của người dùng
  } catch (error) {
    console.error("Error fetching workouts for user:", error);
    res
      .status(500)
      .json({ message: "Failed to fetch workouts", error: error.message });
  }
});

//router.get("/user-workouts/:userId", async function (req, res) {
//  const workoutService = new WorkoutService();
//  const userId = req.params.userId; // Get the userId from the URL
//
//  try {
//    console.log("Fetching workouts for user:", userId); // In ra userId để kiểm tra
//    const workouts = await workoutService.getWorkoutsByUserId(userId);
//    console.log("Workouts found:", workouts); // In ra workouts tìm thấy
//
//    res.json(workouts); // Return the list of workouts for the user
//  } catch (error) {
//    console.error("Error fetching workouts for user:", error);
//    res
//      .status(500)
//      .json({ message: "Failed to fetch workouts", error: error.message });
//  }
//});
router.post("/insert-workout/:userId", async function (req, res) {
  const workoutService = new WorkoutService();
  const workout = new Workout();

  workout.UserId = req.params.userId; // Gắn UserId cho workout
  workout.Title = req.body.Title;
  workout.Description = req.body.Description;
  workout.Exercises = req.body.Exercises; // Array of exercise IDs

  try {
    const result = await workoutService.insertWorkout(workout);
    res.status(201).json({
      message: "Workout added successfully",
      workoutId: result.insertedId,
    });
  } catch (error) {
    console.error("Error adding workout:", error);
    res
      .status(500)
      .json({ message: "Failed to add workout", error: error.message });
  }
});

router.put("/update-workout/:userId/:workoutId", async function (req, res) {
  const workoutService = new WorkoutService();
  const workoutId = req.params.workoutId;
  const userId = req.params.userId;

  try {
    const workout = await workoutService.getWorkout(workoutId);
    if (!workout || workout.UserId !== userId) {
      return res
        .status(404)
        .json({ message: "Workout not found or not owned by user" });
    }

    // Update the workout details
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
router.delete("/delete-workout/:userId/:workoutId", async function (req, res) {
  const workoutService = new WorkoutService();
  const workoutId = req.params.workoutId;
  const userId = req.params.userId;

  try {
    const workout = await workoutService.getWorkout(workoutId);
    if (!workout || workout.UserId !== userId) {
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

module.exports = router;
