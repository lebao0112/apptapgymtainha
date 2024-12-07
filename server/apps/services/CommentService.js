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
    const pipeline = [
      {
        $match: {
          PostId: new ObjectId(postId),
//          ParentId: null, // Lọc các bình luận cha (không phải replies)
        },
      },
      {
        $lookup: {
          from: "Users", // Tên của collection chứa thông tin user
          localField: "UserId", // Trường liên kết trong collection comments
          foreignField: "_id", // Trường liên kết trong collection users
          as: "User", // Tên của trường sẽ chứa thông tin user sau khi populate
        },
      },
      {
        $unwind: {
          path: "$User", // Tách mảng thành object nếu user tồn tại
          preserveNullAndEmptyArrays: true, // Đảm bảo không lỗi nếu user không tồn tại
        },
      },
      {
        $project: {
          _id: 1,
          PostId: 1,
          UserId: 1,
          Content: 1,
          ParentId: 1,
          CreatedAt: 1,
          UpdatedAt: 1,
          "User.Name": 1, // Chỉ giữ lại trường Name từ User
          "User.AvatarUrl": 1, // Chỉ giữ lại trường AvatarUrl từ User
        },
      },
      {
        $skip: skip, // Bỏ qua số lượng comment
      },
      {
        $limit: limit, // Giới hạn số lượng comment trả về
      },
      {
        $sort: {
          CreatedAt: -1, // Sắp xếp theo thời gian mới nhất
        },
      },
    ];

    return await this.commentCollection.aggregate(pipeline).toArray();
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
