var express = require("express");
var app = express();
var controller = require(__dirname + "/apps/controllers");
var bodyParser = require("body-parser");
var dotenv = require("dotenv");
var cron = require("node-cron"); // For scheduling cron jobs

dotenv.config();

app.use(express.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(controller);
app.set("views", __dirname + "/apps/views");
app.set("view engine", "ejs");
app.use("/static", express.static(__dirname + "/public"));

// Start the server
var server = app.listen(3000, async function () {
  console.log("server is running");
});
