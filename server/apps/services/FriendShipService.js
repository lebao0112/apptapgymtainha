const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class FriendShipService {
  databaseConnection = require("./../database/database");
  client;
  friendshipDatabase;
  friendshipCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.friendshipDatabase = this.client.db(config.mongodb.database);
    this.friendshipCollection =
      this.friendshipDatabase.collection("FriendShips");
  }

  // Thêm mới một mối quan hệ bạn bè
  async addFriend(userId1, userId2) {
    const friendship = {
      UserId1: new ObjectId(userId1),
      UserId2: new ObjectId(userId2),
      CreatedAt: new Date(),
      UpdatedAt: new Date(),
    };
    return await this.friendshipCollection.insertOne(friendship);
  }

  // Kiểm tra mối quan hệ bạn bè giữa hai người dùng
  async checkFriendship(userId1, userId2) {
    return await this.friendshipCollection.findOne({
      $or: [
        { UserId1: new ObjectId(userId1), UserId2: new ObjectId(userId2) },
        { UserId1: new ObjectId(userId2), UserId2: new ObjectId(userId1) },
      ],
    });
  }

  // Xóa mối quan hệ bạn bè
  async removeFriend(userId1, userId2) {
    return await this.friendshipCollection.deleteOne({
      $or: [
        { UserId1: new ObjectId(userId1), UserId2: new ObjectId(userId2) },
        { UserId1: new ObjectId(userId2), UserId2: new ObjectId(userId1) },
      ],
    });
  }

  // Lấy danh sách bạn bè của một người dùng
  async getFriends(userId, skip = 0, limit = 100) {
    const cursor = this.friendshipCollection
      .find({
        $or: [
          { UserId1: new ObjectId(userId) },
          { UserId2: new ObjectId(userId) },
        ],
      })
      .skip(skip)
      .limit(limit);

    const friendships = await cursor.toArray();

    // Trả về danh sách các UserId là bạn bè
    return friendships.map((friendship) => {
      return friendship.UserId1.toString() === userId
        ? friendship.UserId2.toString()
        : friendship.UserId1.toString();
    });
  }
}

module.exports = FriendShipService;
