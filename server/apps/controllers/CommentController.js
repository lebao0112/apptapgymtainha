var express = require("express");
var router = express.Router();
var CommentService = require("./../services/CommentService");
var Comment = require("./../entity/comment");
const authenticateToken = require("../middleware/authMiddleware");
const upload = require("../config/uploadS3");
const { ObjectId } = require("mongodb");
const PostService = require("../services/PostService");

router.post("/create-comment", authenticateToken, async function (req, res) {
  const commentService = new CommentService();
  const postService = new PostService();

  const { PostId, Content, ParentId } = req.body;

  if (!Content || !PostId) {
    return res
      .status(400)
      .json({ message: "Content and PostId are required." });
  }

  try {
    const post = await postService.getPost(PostId);
    console.log("🚀 ~ post:", post)

    if (!post) {
      return res.status(404).json({ message: "Post not found." });
    }

    const comment = new Comment();

    comment.Content = Content;
    comment.ParentId = ParentId ? new ObjectId(ParentId) : null;
    comment.PostId = new ObjectId(PostId);
    comment.UserId = new ObjectId(req.user.userId);

    const result = await commentService.insertComment(comment);

    post.Comments =  post.Comments + 1;
    console.log("🚀 ~  post.Comments:",  post.Comments)

    const updatePostResult = await postService.updatePost(post);

    return res.status(201).json({
      message: "Comment created successfully.",
      newComment: {
        _id: result.insertedId,
        ...comment,
      },
    });
  } catch (error) {
    console.error("Error creating comment:", error);
    return res.status(500).json({
      message: "An error occurred while creating the comment.",
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
    
    try {
      const comments = await commentService.getCommentsByPostId(postId);

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
