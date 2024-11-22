const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class PostService {
  databaseConnection = require("./../database/database");
  client;
  postDatabase;
  postCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.postDatabase = this.client.db(config.mongodb.database);
    this.postCollection = this.postDatabase.collection("Posts");
  }

  // Thêm mới một bài đăng
  async insertPost(post) {
    if (!Array.isArray(post.MediaUrls)) {
      throw new Error("mediaUrls must be an array");
    }
    return await this.postCollection.insertOne(post);
  }

  // Lấy thông tin bài đăng theo ID
  async getPost(id) {
    return await this.postCollection.findOne({ _id: new ObjectId(id) });
  }

  // Cập nhật bài đăng
  async updatePost(post) {
    return await this.postCollection.updateOne(
      { _id: new ObjectId(post._id) },
      {
        $set: {
          UserId: post.UserId,
          Content: post.Content,
          MediaType: post.MediaType,
          MediaUrls: post.MediaUrls,
          UpdatedAt: new Date(),
        },
      }
    );
  }

  // Xóa bài đăng theo ID
  async deletePost(id) {
    return await this.postCollection.deleteOne({ _id: new ObjectId(id) });
  }

  // Lấy danh sách bài đăng (có thể giới hạn kết quả trả về)
  async getPostList(skip = 0, limit = 100) {
    const cursor = await this.postCollection.find().skip(skip).limit(limit);
    return await cursor.toArray();
  }
}

module.exports = PostService;
