var express = require("express");
var router = express.Router();
var ChalProgressService = require("./../services/ChalProgressService");
var ChallengeService = require("./../services/ChallengeService");
var Challenge = require("./../entity/Challenge");
const WorkoutService = require("./../services/WorkoutService");
const ExerciseService = require("./../services/ExerciseService");

router.post("/insert-challenge", async function (req, res) {
  const ChallengeService = new ChallengeService();
  const Challenge = new Challenge();
  Challenge.Title = req.body.Title;
  Challenge.Description = req.body.Description;
  Challenge.Exercises = req.body.Exercises; // Array of exercise IDs

  const result = await ChallengeService.insertChallenge(Challenge);
  res.redirect("/challenge/Challenge-list");
});

router.post("/update-challenge", async function (req, res) {
  const challengeService = new ChallengeService();
  const challenge = new Challenge();
  challenge._id = req.body.Id;
  challenge.Title = req.body.Title;
  challenge.Description = req.body.Description;
  challenge.Exercises = req.body.Exercises; // Array of updated exercise IDs

  await challengeService.updateChallenge(challenge);
  res.redirect("/challenge/challenge-list");
});

router.post("/delete-challenge", async function (req, res) {
  const challengeService = new ChallengeService();
  await challengeService.deleteChallenge(req.query.id);
  res.redirect("/challenge/challenge-list");
});

router.get("/challenge-list", async function (req, res) {
  const challengeService = new ChallengeService();
  try {
    const challenges = await challengeService.getChallengeList();
    res.json(challenges);
  } catch (error) {
    console.error("Error fetching exercise list:", error);
    res
      .status(500)
      .json({ message: "Failed to fetch exercise list", error: error.message });
  }
});



router.get("/get-challenge-workouts/:workoutId", async function (req, res) {
  const workoutService = new WorkoutService();
  const exerciseService = new ExerciseService();
  const workoutId = req.params.workoutId;

  try {
    // Fetch the workout by ID
    const workout = await workoutService.getWorkout(workoutId);

    // Check if the workout exists and belongs to the authenticated user
    if (!workout) {
      return res
        .status(404)
        .json({ message: "Workout not found or not owned by user" });
    }

    // Fetch the full exercise details for each exercise in the workout
    const exerciseDetails = await Promise.all(
      workout.Exercises.map(async (exercise) => {
        const exerciseData = await exerciseService.getExercise(
          exercise.exerciseId
        );

      
        return {
          ...exerciseData,
          reps: exercise.reps,
          duration: exercise.duration,
        };
      })
    );


    res.status(200).json({
      ...workout,
      Exercises: exerciseDetails, 
    });
  } catch (error) {
    console.error("Error fetching workout:", error);
    res
      .status(500)
      .json({ message: "Failed to fetch workout", error: error.message });
  }
});

// router.get("/user-challenges/:userId", async function (req, res) {
//   const challengeService = new ChallengeService();
//   const userId = req.params.userId; // Get the userId from the URL

//   try {
//     console.log("Fetching challenges for user:", userId); // In ra userId để kiểm tra
//     const challenges = await challengeService.getChallengesByUserId(userId);
//     console.log("Challenges found:", Challenges); // In ra Challenges tìm thấy

//     res.json(challenges); // Return the list of Challenges for the user
//   } catch (error) {
//     console.error("Error fetching Challenges for user:", error);
//     res
//       .status(500)
//       .json({ message: "Failed to fetch Challenges", error: error.message });
//   }
// });
// router.post("/insert-challenge/:userId", async function (req, res) {
//   const challengeService = new ChallengeService();
//   const challenge = new Challenge();

//   challenge.UserId = req.params.userId; // Gắn UserId cho Challenge
//   challenge.Title = req.body.Title;
//   challenge.Description = req.body.Description;
//   challenge.Exercises = req.body.Exercises; // Array of exercise IDs

//   try {
//     const result = await challengeService.insertChallenge(challenge);
//     res.status(201).json({
//       message: "Challenge added successfully",
//       ChallengeId: result.insertedId,
//     });
//   } catch (error) {
//     console.error("Error adding Challenge:", error);
//     res
//       .status(500)
//       .json({ message: "Failed to add Challenge", error: error.message });
//   }
// });
// router.put("/update-challenge/:userId/:challengeId", async function (req, res) {
//   const challengeService = new ChallengeService();
//   const challengeId = req.params.ChallengeId;
//   const userId = req.params.userId;

//   try {
//     const challenge = await challengeService.getChallenge(challengeId);
//     if (!challenge || challenge.UserId !== userId) {
//       return res
//         .status(404)
//         .json({ message: "Challenge not found or not owned by user" });
//     }

//     // Update the Challenge details
//     challenge.Title = req.body.Title || challenge.Title;
//     challenge.Description = req.body.Description || challenge.Description;
//     challenge.Exercises = req.body.Exercises || challenge.Exercises;

//     await challengeService.updateChallenge(challenge);
//     res.status(200).json({ message: "Challenge updated successfully" });
//   } catch (error) {
//     console.error("Error updating Challenge:", error);
//     res
//       .status(500)
//       .json({ message: "Failed to update Challenge", error: error.message });
//   }
// });
// router.delete("/delete-Challenge/:userId/:ChallengeId", async function (req, res) {
//   const ChallengeService = new ChallengeService();
//   const ChallengeId = req.params.ChallengeId;
//   const userId = req.params.userId;

//   try {
//     const Challenge = await ChallengeService.getChallenge(ChallengeId);
//     if (!Challenge || Challenge.UserId !== userId) {
//       return res
//         .status(404)
//         .json({ message: "Challenge not found or not owned by user" });
//     }

//     await ChallengeService.deleteChallenge(ChallengeId);
//     res.status(200).json({ message: "Challenge deleted successfully" });
//   } catch (error) {
//     console.error("Error deleting Challenge:", error);
//     res
//       .status(500)
//       .json({ message: "Failed to delete Challenge", error: error.message });
//   }
// });

module.exports = router;
