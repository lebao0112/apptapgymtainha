var express = require("express");
var router = express.Router();
const authenticateToken = require("../../middleware/authMiddleware");
const {
  sendNotificationToAllDevices,
  sendNotificationToSpecificDevice
} = require("../../services/SendNotificationService");
const authorizeRole = require("../../middleware/authorizeRole");


router.post(
  "/send", authenticateToken, authorizeRole("admin"),
  async function (req, res) {
    const { title, content, icon, imageUrl } = req.body;
     try {
       await sendNotificationToAllDevices({ title, content, icon, imageUrl });
       res.status(200).send("Notification sent!");
     } catch (error) {
       res.status(500).send(`Error sending notification: ${error.message}`);
     }
  }
);

router.post("/specific", async function (req, res) {
  const { playerId, message } = req.body;
  console.log("🚀 ~ Player ID:", playerId);
  console.log("🚀 ~ Message:", message);

  try {
    await sendNotificationToSpecificDevice(playerId, message);
    res.status(200).send("Notification sent to specific device!");
  } catch (error) {
    console.error("Error in sending notification to specific device:", error);
    res.status(500).send(`Error sending notification: ${error.message}`);
  }
});

module.exports = router;
