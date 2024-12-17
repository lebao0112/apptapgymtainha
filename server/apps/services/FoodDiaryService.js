const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class FoodDiaryService {
  databaseConnection = require("./../database/database");
  client;
  foodDiaryDatabase;
  foodDiaryCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.foodDiaryDatabase = this.client.db(config.mongodb.database);
    this.foodDiaryCollection = this.foodDiaryDatabase.collection("FoodDiaries");
  }

  // Insert new food diary
  async insertFoodDiary(foodDiary) {
    console.log("Inserting food diary:", foodDiary);  // In ra dữ liệu để kiểm tra
    return await this.foodDiaryCollection.insertOne(foodDiary);
  }

  // Get a food diary by userId and date
  async getFoodDiaryByDate(userId, date) {
    console.log("Inserting id:", userId);
    console.log("Inserting date:", date);
    try {
      const foodDiary = await this.foodDiaryCollection.findOne({
        userId: userId, // Lấy food diary theo userId
        date: new Date(date), // Convert chuỗi thành đối tượng Date
      });
      return foodDiary;
    } catch (error) {
      console.error("Error fetching food diary by date:", error);
      throw error;
    }
  }

  // Update an existing food diary
  async updateFoodDiary(foodDiary) {
    return await this.foodDiaryCollection.updateOne(
      { _id: new ObjectId(foodDiary._id) },
      {
        $set: {
          breakfast: foodDiary.breakfast,  // Mảng các món ăn cho bữa sáng
          lunch: foodDiary.lunch,          // Mảng các món ăn cho bữa trưa
          dinner: foodDiary.dinner,        // Mảng các món ăn cho bữa tối
        },
      }
    );
  }

  // Delete a food diary by userId and date
  async deleteFoodDiary(userId, date) {
    return await this.foodDiaryCollection.deleteOne({
      userId: new ObjectId(userId),
      date: new Date(date),
    });
  }

  // Get all food diaries for a user (for example, for a week or month)
  async getFoodDiariesByUser(userId) {
    const cursor = await this.foodDiaryCollection.find({ userId: new ObjectId(userId) }).skip(0).limit(100);
    return await cursor.toArray();
  }

  // Get food diaries for a specific date range (e.g., for a week or month)
  async getFoodDiariesByRange(userId, startDate, endDate) {
    const cursor = await this.foodDiaryCollection.find({
      userId: new ObjectId(userId),
      date: {
        $gte: new Date(startDate),
        $lte: new Date(endDate),
      },
    });
    return await cursor.toArray();
  }

  // Get food diary for a specific userId and challengeId
  async getFoodDiaryByUserIdAndDate(userId, date) {
    try {
      const objectId = new ObjectId(userId);
      return await this.foodDiaryCollection.findOne({
        userId: objectId,
        date: new Date(date),
      });
    } catch (error) {
      console.error("Error fetching food diary by userId and date:", error);
      return null;
    }
  }
}

module.exports = FoodDiaryService;
