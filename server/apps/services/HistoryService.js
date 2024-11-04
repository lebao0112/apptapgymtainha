const { ObjectId } = require("mongodb");
const config = require("./../config/setting.json");

class HistoryService {
  databaseConnection = require("./../database/database");
  client;
  historyDatabase;
  historyCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.historyDatabase = this.client.db(config.mongodb.database);
    this.historyCollection = this.historyDatabase.collection("Histories");
  }

  async insertHistory(history) {
    return await this.historyCollection.insertOne(history);
  }

  async getHistoryByUserId(userId) {
     return await this.historyCollection
       .find({ UserId: userId }) // Không dùng ObjectId(userId)
       .toArray();
  }

  async deleteHistory(id) {
    return await this.historyCollection.deleteOne({ _id: new ObjectId(id) });
  }

  async getAllHistories() {
    const cursor = await this.historyCollection.find();
    return await cursor.toArray();
  }
}

module.exports = HistoryService;
