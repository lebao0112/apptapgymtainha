var express = require("express");
var router = express.Router();
var PostService = require("./../services/PostService");
var Post = require("./../entity/post");
const authenticateToken = require("../middleware/authMiddleware");

router.post("/add-post", authenticateToken, async function (req, res) {
  const postService = new PostService();
  const { Content, MediaType, MediaUrls} = req.body;
  const UserId = req.user.userId;

  const post = new Post(
    UserId,
    Content,
    MediaType,
    MediaUrls
  );

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
});

module.exports = router;