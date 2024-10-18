const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class ChallengeService {
  databaseConnection = require("./../database/database");
  client;
  challengeDatabase;
  challengeCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.challengeDatabase = this.client.db(config.mongodb.database);
    this.challengeCollection = this.challengeDatabase.collection("challenges");
  }

  async insertChallenge(challenge) {
    return await this.challengeCollection.insertOne(challenge);
  }

  async getChallenge(id) {
    return await this.challengeCollection.findOne({ _id: new ObjectId(id) });
  }

  async updateChallenge(challenge) {
    return await this.challengeCollection.updateOne(
      { _id: new ObjectId(challenge._id) },
      { $set: challenge }
    );
  }

  async deleteChallenge(id) {
    return await this.challengeCollection.deleteOne({ _id: new ObjectId(id) });
  }

  async getChallengeList() {
    const cursor = await this.challengeCollection.find().skip(0).limit(100);
    return await cursor.toArray();
  }
}

module.exports = ChallengeService;
