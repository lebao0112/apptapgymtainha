const { ObjectId } = require("mongodb");
var config = require("./../config/setting.json");

class LikeService {
  databaseConnection = require("./../database/database");
  client;
  likeDatabase;
  likeCollection;

  constructor() {
    this.client = this.databaseConnection.getMongoClient();
    this.likeDatabase = this.client.db(config.mongodb.database);
    this.likeCollection = this.likeDatabase.collection("Likes");
  }

  // Thêm like mới
  async insertLike(like) {
    return await this.likeCollection.insertOne(like);
  }

  // Lấy thông tin like theo ID
  async getLike(id) {
    return await this.likeCollection.findOne({ _id: new ObjectId(id) });
  }

  // Lấy danh sách like của một bài đăng
  async getLikesByPostId(postId, skip = 0, limit = 100) {
    const cursor = await this.likeCollection
      .find({ PostId: new ObjectId(postId) })
      .skip(skip)
      .limit(limit);
    return await cursor.toArray();
  }

  // Lấy danh sách like của một bình luận
  async getLikesByCommentId(commentId, skip = 0, limit = 100) {
    const cursor = await this.likeCollection
      .find({ CommentId: new ObjectId(commentId) })
      .skip(skip)
      .limit(limit);
    return await cursor.toArray();
  }

  // Kiểm tra nếu người dùng đã like một bài đăng hoặc bình luận
  async checkIfUserLiked(postId, commentId, userId) {
    return await this.likeCollection.findOne({
      PostId: postId ? new ObjectId(postId) : null,
      CommentId: commentId ? new ObjectId(commentId) : null,
      UserId: userId,
    });
  }

  // Xóa like theo ID
  async deleteLike(id) {
    return await this.likeCollection.deleteOne({ _id: new ObjectId(id) });
  }

  // Xóa like theo PostId, CommentId và UserId (Un-like)
  async removeLike(postId, commentId, userId) {
    return await this.likeCollection.deleteOne({
      PostId: postId ? new ObjectId(postId) : null,
      CommentId: commentId ? new ObjectId(commentId) : null,
      UserId: userId,
    });
  }
}

module.exports = LikeService;
