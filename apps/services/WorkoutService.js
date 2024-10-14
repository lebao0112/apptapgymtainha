const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json"); // Nạp file config
class WorkoutService {
  databaseConnection = require("./../database/database");
  client;
  workoutDatabase;
  workoutCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.workoutDatabase = this.client.db(config.mongodb.database);
    this.workoutCollection = this.workoutDatabase.collection("Workouts");
  }

  async insertWorkout(workout) {
    return await this.workoutCollection.insertOne(workout);
  }

  async getWorkout(id) {
    return await this.workoutCollection.findOne({ _id: new ObjectId(id) });
  }

  async updateWorkout(workout) {
    return await this.workoutCollection.updateOne(
      { _id: new ObjectId(workout._id) },
      { $set: workout }
    );
  }

  async deleteWorkout(id) {
    return await this.workoutCollection.deleteOne({ _id: new ObjectId(id) });
  }

  async getWorkoutList() {
    const cursor = await this.workoutCollection.find().skip(0).limit(100);
    return await cursor.toArray();
  }
  async getWorkoutsByUserId(userId) {
    // Chuyển đổi userId thành ObjectId trước khi truy vấn
    return await this.workoutCollection
      .find({ UserId: userId }) // Không dùng ObjectId(userId)
      .toArray();
  }
}
module.exports = WorkoutService;
