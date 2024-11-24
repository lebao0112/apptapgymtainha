var express = require("express");
var router = express.Router();
var PostService = require("./../services/PostService");
var Post = require("./../entity/post");
const authenticateToken = require("../middleware/authMiddleware");
const upload = require("../config/uploadS3"); 

router.post(
  "/create-post",
  authenticateToken,
  upload.array("files", 10),
  async function (req, res) {
    console.log("🚀 ~ req:", req.body)
    const postService = new PostService;
    
    const { Content, MediaType } = req.body;
    console.log("🚀 ~ MediaType:", MediaType)
    console.log("🚀 ~ Content:", Content)
    const MediaUrls = req.files.map((file) => file.location);
    const UserId = req.user.userId;

    const post = new Post();
   
    post.Content = req.body.Content;
    post.MediaType = req.body.MediaType;
    post.UserId = req.user.userId;
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

module.exports = router;