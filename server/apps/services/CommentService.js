const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class CommentService {
  databaseConnection = require("./../database/database");
  client;
  commentDatabase;
  commentCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.commentDatabase = this.client.db(config.mongodb.database);
    this.commentCollection = this.commentDatabase.collection("Comments");
  }

  // Thêm mới một bình luận
  async insertComment(comment) {
    return await this.commentCollection.insertOne(comment);
  }

  // Lấy thông tin bình luận theo ID
  async getComment(id) {
    return await this.commentCollection.findOne({ _id: new ObjectId(id) });
  }

  // Lấy danh sách bình luận của một bài đăng
  async getCommentsByPostId(postId, skip = 0, limit = 100) {
    const cursor = await this.commentCollection
      .find({ PostId: new ObjectId(postId) })
      .skip(skip)
      .limit(limit);
    return await cursor.toArray();
  }

  // Cập nhật nội dung của một bình luận
  async updateComment(comment) {
    return await this.commentCollection.updateOne(
      { _id: new ObjectId(comment._id) },
      {
        $set: {
          Content: comment.Content,
          UpdatedAt: new Date(),
        },
      }
    );
  }

  // Xóa một bình luận theo ID
  async deleteComment(id) {
    return await this.commentCollection.deleteOne({ _id: new ObjectId(id) });
  }
}

module.exports = CommentService;
