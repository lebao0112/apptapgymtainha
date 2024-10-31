var express = require("express");
var app = express();
var controller = require(__dirname + "/apps/controllers");
var bodyParser = require("body-parser");
var dotenv = require("dotenv");
var cron = require("node-cron"); // For scheduling cron jobs
var StepCounterProgressService = require("./apps/services/stepcounterprogressService"); // Your progress service

dotenv.config();

app.use(express.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(controller);
app.set("views", __dirname + "/apps/views");
app.set("view engine", "ejs");
app.use("/static", express.static(__dirname + "/public"));

var stepCounterProgressService = new StepCounterProgressService();

// Function to reset progress for all users
async function resetProgressForAllUsers() {
  console.log("Resetting progress for all users...");
  const today = new Date().toISOString().slice(0, 10); // Get today's date in YYYY-MM-DD format

  try {
    const users = await stepCounterProgressService.getAllProgress(); // Get all user progress

    // Loop through each user and reset their progress
    users.forEach(async (user) => {
      try {
        await stepCounterProgressService.resetProgress(user.userId, today);
        console.log(`Progress reset for user: ${user.userId}`);
      } catch (error) {
        console.error(`Failed to reset progress for user: ${user.userId}`, error);
      }
    });
  } catch (error) {
    console.error("Failed to reset daily progress for users", error);
  }
}

// Schedule daily progress reset at midnight
cron.schedule("0 0 * * *", async () => {
  console.log("Running scheduled daily progress reset...");
  await resetProgressForAllUsers();
});

// Check and reset on server startup if needed
async function checkAndResetOnStartup() {
  console.log("Checking for missed reset...");
  const lastResetDate = await stepCounterProgressService.getLastResetDate(); // You need to track the last reset date in your DB
  const today = new Date().toISOString().slice(0, 10); // Today's date in YYYY-MM-DD format

  // If the last reset was not today, perform the reset
  if (lastResetDate !== today) {
    await resetProgressForAllUsers();
    await stepCounterProgressService.updateLastResetDate(today); // Update the last reset date to today
  } else {
    console.log("Reset already performed today, no action needed.");
  }
}

// Start the server
var server = app.listen(3000, async function () {
  console.log("server is running");
  await checkAndResetOnStartup(); // Check and reset progress on server startup if needed
});
