const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");
class ProgressService {
  databaseConnection = require("./../database/database");
  client;
  progressDatabase;
  progressCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.progressDatabase = this.client.db(config.mongodb.database);
    this.progressCollection = this.progressDatabase.collection("Progress");
  }

  async insertProgress(progress) {
    return await this.progressCollection.insertOne(progress);
  }

  async getProgress(id) {
    return await this.progressCollection.findOne({ _id: new ObjectId(id) });
  }

  async updateProgress(progress) {
    return await this.progressCollection.updateOne(
      { _id: new ObjectId(progress._id) },
      { $set: progress }
    );
  }

  async deleteProgress(id) {
    return await this.progressCollection.deleteOne({ _id: new ObjectId(id) });
  }

  async getProgressList() {
    const cursor = await this.progressCollection.find().skip(0).limit(100);
    return await cursor.toArray();
  }
}
module.exports = ProgressService;
