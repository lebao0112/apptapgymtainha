var express = require("express");
var router = express.Router();
var PostService = require("./../services/PostService");
var LikeService = require("./../services/LikeService");
var CommentService = require("./../services/CommentService");
// var UserService = require("./../services/UserService");
var Post = require("./../entity/post");
const authenticateToken = require("../middleware/authMiddleware");
const {upload} = require("../config/uploadS3");
const { ObjectId } = require("mongodb");
const { user } = require("../database/database");

router.post(
  "/create-post",
  authenticateToken,
  upload.array("files", 10),
  async function (req, res) {
    const postService = new PostService();

    const { Content, MediaType } = req.body;
    const post = new Post();

    post.Content = req.body.Content ?? "";
    post.MediaType = req.body.MediaType;
    post.UserId = new ObjectId(req.user.userId);
    post.MediaUrls = req.files.map((file) => file.location);
    console.log("🚀 ~ post:", post);

    try {
      const result = await postService.insertPost(post);
      res.status(201).json({
        message: "Post added successfully",
        postId: result.insertedId,
      });
    } catch (error) {
      console.error("Error adding history:", error);
      res.status(500).json({
        message: "Failed to add history",
        error: error.message,
      });
    }
  }
);

router.get("/get-posts", authenticateToken, async function (req, res) {
  const { page = 1, limit = 100 } = req.query;
  const skip = (page - 1) * limit;

  const userId = req.user.userId;

  const postService = new PostService();
  const likeService = new LikeService();
  try {
    const posts = await postService.getPostList(skip, limit);
    const total = await postService.countDocuments();

    const postsWithLikesStatus = await Promise.all(
      posts.map(async (post) => {
        const like = await likeService.checkIfUserLiked(post._id, null, userId);
        return {
          ...post,
          isLiked: like ? true : false,
        };
      })
    );

    postsWithLikesStatus.sort(
      (a, b) => new Date(b.CreatedAt) - new Date(a.CreatedAt)
    );

    res.status(200).json({
      posts: postsWithLikesStatus,
      total,
      hasMore: skip + posts.length < total,
    });
  } catch (error) {
    console.error("Error fetching post list:", error);
    res.status(500).json({
      message: "Failed to fetch post list",
      error: error.message,
    });
  }
});

router.delete("/delete-post", authenticateToken, async function (req, res){
  const postId = req.query.postId || "";
  const userId = req.user.userId;
  const postService = new PostService();

   try {
    
     const post = await postService.getPost(postId);

      if (!post) {
        return res.status(404).json({
          message: "Post not found.",
        });

      }


     if (!post.UserId.equals(new ObjectId(userId))) {
       console.log("🚀 ~ userId:", userId);
       console.log("🚀 ~ post.UserId:", post.UserId);
       return res.status(403).json({
         messsage: "You do not have permission to access this post.",
       });
     }
   
 
    const deleteResult = await postService.deletePost(postId);

    if (deleteResult.deletedCount === 1) {
      return res.status(200).json({
        message: `Post ${postId} was deleted successfully.`,
      });
    } else {
      return res.status(500).json({
        message: "Failed to delete post. Please try again later.",
      });
    }
    
    
   } catch (error) {
     console.error("Error deleting post:", error);
     res.status(500).json({
       message: "Failed to delete post",
       error: error.message,
     });
   }

});

router.get("/search-posts", authenticateToken, async function (req, res) {
  const keyword = req.query.keyword || "";
  const page = parseInt(req.query.page, 10) || 1; // Convert to number
  const limit = parseInt(req.query.limit, 10) || 10; // Convert to number
  const skip = (page - 1) * limit;
  const userId = req.user.userId;
  const postService = new PostService();
  const likeService = new LikeService();

  try {
    const posts = await postService.searchPosts(keyword, skip, limit);
    const total = await postService.countSearchResults(keyword);

     const postsWithLikesStatus = await Promise.all(
       posts.map(async (post) => {
         const like = await likeService.checkIfUserLiked(
           post._id,
           null,
           userId
         );
         return {
           ...post,
           isLiked: like ? true : false,
         };
       })
     );
    res.status(200).json({
      posts: postsWithLikesStatus,
      total,
      hasMore: skip + posts.length < total
    });
  } catch (error) {
    console.error("Error searching posts:", error);
    res.status(500).json({
      message: "Failed to search posts",
      error: error.message,
    });
  }
});

module.exports = router;
