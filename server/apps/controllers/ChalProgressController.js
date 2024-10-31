// controllers/ChalProgressController.js
var express = require("express");
var router = express.Router();
var ChalProgressService = require("./../services/ChalProgressService");
var ChalProgress = require("./../entity/chalprogress");
const signToken = require("../middleware/generateToken");
const authenticateToken = require("../middleware/authMiddleware");
const jwt = require("jsonwebtoken");
const { ObjectId } = require("mongodb");
// Insert a new challenge progress
router.post(
  "/insert-chalprogress/:challengeId", authenticateToken,
  async function (req, res) {
    const chalProgressService = new ChalProgressService();
    const chalProgress = new ChalProgress();

    chalProgress.UserId = new ObjectId(req.user.userId);
    chalProgress.ChallengeId = new ObjectId(req.params.challengeId);
    chalProgress.Progress = 0;

    try {
      const result = await chalProgressService.insertChalProgress(chalProgress);
      res.status(201).json({
        message: "Challenge progress added successfully",
        chalProgressId: result.insertedId,
      });
    } catch (error) {
      console.error("Error adding challenge progress:", error);
      res.status(500).json({
        message: "Failed to add challenge progress",
        error: error.message,
      });
    }
  }
);

// Update progress for a specific challenge
router.put(
  "/update-chalprogress/:userId/:challengeId",
  async function (req, res) {
    const chalProgressService = new ChalProgressService();
    const userId = req.params.userId;
    const challengeId = req.params.challengeId;

    try {
      const chalProgress = await chalProgressService.getChalProgressByChallenge(
        userId,
        challengeId
      );
      if (!chalProgress) {
        return res
          .status(404)
          .json({ message: "Challenge progress not found" });
      }

      chalProgress.CompletedDays =
        req.body.CompletedDays || chalProgress.CompletedDays;

      await chalProgressService.updateChalProgress(chalProgress);
      res
        .status(200)
        .json({ message: "Challenge progress updated successfully" });
    } catch (error) {
      console.error("Error updating challenge progress:", error);
      res.status(500).json({
        message: "Failed to update challenge progress",
        error: error.message,
      });
    }
  }
);

// Delete a challenge progress
router.delete(
  "/delete-chalprogress/:userId/:challengeId",
  async function (req, res) {
    const chalProgressService = new ChalProgressService();
    const userId = req.params.userId;
    const challengeId = req.params.challengeId;

    try {
      const chalProgress = await chalProgressService.getChalProgressByChallenge(
        userId,
        challengeId
      );
      if (!chalProgress) {
        return res
          .status(404)
          .json({ message: "Challenge progress not found" });
      }

      await chalProgressService.deleteChalProgress(chalProgress._id);
      res
        .status(200)
        .json({ message: "Challenge progress deleted successfully" });
    } catch (error) {
      console.error("Error deleting challenge progress:", error);
      res.status(500).json({
        message: "Failed to delete challenge progress",
        error: error.message,
      });
    }
  }
);

router.get("/chalprogress-list", authenticateToken, async function (req, res) {
  const chalProgressService = new ChalProgressService();
   const userId = new ObjectId(req.user.userId);

  try {
    const chalProgressList = await chalProgressService.getChalProgressList(
      userId
    );
    if (!chalProgressList) {
      return res.status(404).json({ message: "Challenge progress not found" });
    }
    res.status(200).json(chalProgressList);
  } catch (error) {
    console.error("Error fetching challenge progress:", error);
    res.status(500).json({
      message: "Failed to fetch challenge progress",
      error: error.message,
    });
  }
});

// Get all challenge progress for a user
router.get("/user-chalprogress/:userId", async function (req, res) {
  const chalProgressService = new ChalProgressService();
  const userId = req.params.userId;

  try {
    const chalProgress = await chalProgressService.getChalProgressByUserId(
      userId
    );
    res.status(200).json(chalProgress);
  } catch (error) {
    console.error("Error fetching challenge progress for user:", error);
    res.status(500).json({
      message: "Failed to fetch challenge progress",
      error: error.message,
    });
  }
});

router.get("/chalprogress-list", async function (req, res) {
  const chalProgressService = new ChalProgressService();

  try {
    const chalProgressList = await chalProgressService.getChalProgressList();
    res.status(200).json(chalProgressList); // Return the list of chalprogress entries
  } catch (error) {
    console.error("Error fetching chalprogress list:", error);
    res.status(500).json({
      message: "Failed to fetch chalprogress list",
      error: error.message,
    });
  }
});

module.exports = router;
