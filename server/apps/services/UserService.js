const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class UserService {
  databaseConnection = require("./../database/database");
  client;
  userDatabase;
  userCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.userDatabase = this.client.db(config.mongodb.database);
    this.userCollection = this.userDatabase.collection("Users");
  }

  async insertUser(user) {
    return await this.userCollection.insertOne(user);
  }

  async getUser(id) {
    return await this.userCollection.findOne({ _id: new ObjectId(id) });
  }

  async updateUser(userId, updatedFields) {
    try {
      const result = await this.userCollection.findOneAndUpdate(
        { _id: new ObjectId(userId) }, // Tìm user theo _id
        { $set: updatedFields }, // Chỉ cập nhật các trường hợp lệ
        { returnDocument: "after", returnNewDocument: true } // Trả về document sau khi cập nhật
      );

      return result; // Trả về user đã cập nhật
    } catch (error) {
      console.error("Error in updateUser:", error);
      throw error;
    }
  }
  // async updateUser(user) {
  //   return await this.userCollection.updateOne(
  //     { _id: new ObjectId(user._id) },
  //     { $set: user }
  //   );
  // }

  async deleteUser(id) {
    return await this.userCollection.deleteOne({ _id: new ObjectId(id) });
  }

  async getUserList() {
    const cursor = await this.userCollection.find().skip(0).limit(100);
    return await cursor.toArray();
  }
  async getUserByEmail(email) {
    return await this.userCollection.findOne({ Email: email });
  }

  async updateUserName(userId, newName) {
    const result = await this.userCollection.updateOne(
      { _id: new ObjectId(userId) },
      { $set: { Name: newName } }
    );
    return result;
  }
}
module.exports = UserService;
