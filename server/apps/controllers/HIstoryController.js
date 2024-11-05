const express = require("express");
const router = express.Router();
const HistoryService = require("./../services/HistoryService");
const History = require("./../entity/history");
const authenticateToken = require("../middleware/authMiddleware");

router.post("/add-history", authenticateToken, async function (req, res) {
  const historyService = new HistoryService();
  const { WorkoutName, WorkoutId, Date, TotalTime, Calories } = req.body;
  const UserId = req.user.userId;

  const history = new History(
    UserId,
    WorkoutName,
    WorkoutId,
    Date,
    TotalTime,
    Calories
  );

  try {
    const result = await historyService.insertHistory(history);
    res.status(201).json({
      message: "History added successfully",
      historyId: result.insertedId,
    });
  } catch (error) {
    console.error("Error adding history:", error);
    res.status(500).json({
      message: "Failed to add history",
      error: error.message,
    });
  }
});


router.get("/user-history", authenticateToken, async function (req, res) {
  const historyService = new HistoryService();
  const userId = req.user.userId;

  try {
    const histories = await historyService.getHistoryByUserId(userId);
    console.log("🚀 ~ histories:", histories)
    res.json(histories);
  } catch (error) {
    console.error("Error fetching user history:", error);
    res.status(500).json({
      message: "Failed to fetch user history",
      error: error.message,
    });
  }
});


router.delete(
  "/delete-history/:historyId",
  authenticateToken,
  async function (req, res) {
    const historyService = new HistoryService();
    const historyId = req.params.historyId;

    try {
      await historyService.deleteHistory(historyId);
      res.status(200).json({ message: "History deleted successfully" });
    } catch (error) {
      console.error("Error deleting history:", error);
      res.status(500).json({
        message: "Failed to delete history",
        error: error.message,
      });
    }
  }
);

module.exports = router;
