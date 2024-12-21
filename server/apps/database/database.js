const { use } = require("../controllers");
var config = require("./../config/setting.json");
class DatabaseConnection {
  url;
  user;
  pass;
  constructor() {}
  static getMongoClient() {
    this.user = config.mongodb.username;
    this.pass = config.mongodb.password;
    this.database = config.mongodb.database;
    // this.url = `mongodb+srv://${this.user}:${this.pass}@cluster0.uwxidxt.mongodb.net/?retryWrites=true&w=majority`;
    // this.url = `mongodb+srv://${this.user}:${this.pass}@cluster0.pqkmf.mongodb.net/`;
    this.url = `mongodb://${this.user}:${this.pass}@localhost:27017/${this.database}`;
    const { MongoClient } = require("mongodb");
    const client = new MongoClient(this.url);
    return client;
  }
}
module.exports = DatabaseConnection;
