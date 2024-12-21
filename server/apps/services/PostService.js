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
          Likes: post.Likes,
          Comments: post.Comments,
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
    try {
      const posts = await this.postCollection
        .aggregate([
          {
            $lookup: {
              from: "Users", // Tên collection chứa thông tin người dùng
              localField: "UserId", // Trường trong collection Posts để join
              foreignField: "_id", // Trường trong collection Users để join
              as: "userinfo", // Tên trường sẽ chứa dữ liệu kết hợp
            },
          },
          {
            $unwind: { path: "$userinfo", preserveNullAndEmptyArrays: true }, // Giải nén mảng userinfo (null nếu không tìm thấy người dùng)
          },
          {
            $project: {
              _id: 1,
              UserId: 1,
              Content: 1,
              MediaUrls: 1,
              CreatedAt: 1,
              UpdatedAt: 1,
              Likes: 1,
              Comments: 1,
              "userinfo.Name": 1,
              "userinfo.AvatarUrl": 1,
              "userinfo._id": 1,
            },
          },
          {
            $skip: skip, // Bỏ qua số lượng bài đăng (phân trang)
          },
          {
            $limit: limit, // Giới hạn số lượng bài đăng trả về
          },
        ])
        .toArray();

      return posts;
    } catch (error) {
      console.error("Error fetching post list with user info:", error);
      throw new Error("Failed to fetch post list with user info");
    }
  }

  async countDocuments(){
    return await this.postCollection.countDocuments();
  }
}

module.exports = PostService;
