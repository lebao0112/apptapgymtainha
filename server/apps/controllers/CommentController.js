var express = require("express");
var router = express.Router();
var CommentService = require("./../services/CommentService");
var Comment = require("./../entity/comment");
const authenticateToken = require("../middleware/authMiddleware");
const upload = require("../config/uploadS3");
const { ObjectId } = require("mongodb");

router.post("/create-comment", authenticateToken, async function (req, res) {
  const commentService = new CommentService();

  const { PostId, Content, ParentId } = req.body;

  if (!Content || !PostId) {
    return res.status(401).json({ message: "Invalid request" });
  }

  const comment = new Comment();

  comment.Content = Content;
  comment.ParentId = ParentId ? new ObjectId(ParentId) : null;
  comment.PostId = new ObjectId(PostId);
  comment.UserId = new ObjectId(req.user.userId);

  console.log("🚀 ~ comment:", comment);

  try {
    const result = await commentService.insertComment(comment);
    res.status(201).json({
      message: "Comment created successfully.",
      newComment: {
        _id: result.insertedId,
        ...comment,
      },
    });
  } catch (error) {
    console.error("Error creating comment:", error);
    res.status(500).json({
      message: "Failed to create comment",
      error: error.message,
    });
  }
});

router.get(
  "/get-comments-by-post/:postId",
  authenticateToken,
  async function (req, res) {
    //Lấy danh sách comments cho một bài post và replies
    const commentService = new CommentService();
    const postId  = req.params.postId;
    console.log("🚀 ~ PostId:", postId)
    
    try {
      const comments = await commentService.getCommentsByPostId(postId);
      console.log("🚀 ~ comments:", comments)

      res.status(200).json({
        comments,
      });
    } catch (error) {
      res.status(500).json({
        message: `Failed to get comments for post ${postId}`,
        error: error.message,
      });
    }
  }
);

module.exports = router;
