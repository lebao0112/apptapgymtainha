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

  async getPost(id) {
    return await this.postCollection.findOne({ _id: new ObjectId(id) });
  }


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

  async deletePost(id) {
    return await this.postCollection.deleteOne({ _id: new ObjectId(id) });
  }


  async getPostList(skip = 0, limit = 100) {
    try {
      const posts = await this.postCollection
        .aggregate([
          {
            $lookup: {
              from: "Users", 
              localField: "UserId", 
              foreignField: "_id", 
              as: "userinfo", 
            },
          },
          {
            $unwind: { path: "$userinfo", preserveNullAndEmptyArrays: true }, 
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

  async searchPosts(keyword, skip = 0, limit = 10) {
    try {
      const regex = new RegExp(keyword, "i"); // Case-insensitive regex search
      const posts = await this.postCollection
        .aggregate([
          {
            $match: {
              Content: { $regex: regex },
            },
          },
          {
            $lookup: {
              from: "Users",
              localField: "UserId",
              foreignField: "_id",
              as: "userinfo",
            },
          },
          {
            $unwind: { path: "$userinfo", preserveNullAndEmptyArrays: true },
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
            $sort: { CreatedAt: -1 }, // Sắp xếp theo thời gian từ mới nhất đến cũ nhất
          },
          { $skip: skip },
          { $limit: limit },
        ])
        .toArray();

      return posts;
    } catch (error) {
      console.error("Error searching posts:", error);
      throw new Error("Failed to search posts");
    }
  }

  // Count total search results
  async countSearchResults(keyword) {
    try {
      const regex = new RegExp(keyword, "i");
      return await this.postCollection.countDocuments({
        Content: { $regex: regex },
      });
    } catch (error) {
      console.error("Error counting search results:", error);
      throw new Error("Failed to count search results");
    }
  }

  async countDocuments() {
    return await this.postCollection.countDocuments();
  }
}

module.exports = PostService;
