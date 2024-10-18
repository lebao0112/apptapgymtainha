const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class ExerciseService {
  databaseConnection = require("./../database/database");
  client;
  exerciseDatabase;
  exerciseCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.exerciseDatabase = this.client.db(config.mongodb.database);
    this.exerciseCollection = this.exerciseDatabase.collection("Exercises");
  }

  async insertExercise(exercise) {
    return await this.exerciseCollection.insertOne(exercise);
  }

  async getExercise(id) {
    return await this.exerciseCollection.findOne({ _id: new ObjectId(id) });
  }

  async updateExercise(exercise) {
    return await this.exerciseCollection.updateOne(
      { _id: new ObjectId(exercise._id) },
      { $set: exercise }
    );
  }

  async deleteExercise(id) {
    return await this.exerciseCollection.deleteOne({ _id: new ObjectId(id) });
  }

  async getExerciseList() {
    const cursor = await this.exerciseCollection.find().skip(0).limit(100);
    return await cursor.toArray();
  }
}
module.exports = ExerciseService;
