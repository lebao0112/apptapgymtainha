const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class ChalProgressService {
  databaseConnection = require("./../database/database");
  client;
  progressDatabase;
  progressCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.progressDatabase = this.client.db(config.mongodb.database);
    this.progressCollection = this.progressDatabase.collection("ChalProgress");
  }

  async insertChalProgress(chalProgress) {
    return await this.progressCollection.insertOne(chalProgress);
  }

  async getChalProgress(id) {
    return await this.progressCollection.findOne({ _id: new ObjectId(id) });
  }

  async updateChalProgress(chalProgress) {
    return await this.progressCollection.updateOne(
      { _id: new ObjectId(chalProgress._id) },
      { $set: chalProgress }
    );
  }

  async deleteChalProgress(id) {
    return await this.progressCollection.deleteOne({ _id: new ObjectId(id) });
  }

  async getChalProgressList() {
    const cursor = await this.progressCollection.find().skip(0).limit(100);
    return await cursor.toArray();
  }

  async getChalProgressListByUserId(userId) {
    const cursor = await this.progressCollection.find(userId).skip(0).limit(100);
    return await cursor.toArray();
  }

  async getChalProgressByUserId(userId) {
    try {
      const objectId = new ObjectId(userId);
      return await this.progressCollection.find({ UserId: objectId }).toArray();
    } catch (error) {
      console.error("Invalid ObjectId for UserId:", userId);
      return [];
    }
  }
  async getChalProgressByChallenge(userId, challengeId) {
    return await this.progressCollection.findOne({
      UserId: userId,
      ChallengeId: challengeId,
    });
  }
}

module.exports = ChalProgressService;
