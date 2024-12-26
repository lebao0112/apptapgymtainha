var express = require("express");
var router = express.Router();
var LikeService = require("./../services/LikeService");
var Like = require("./../entity/like");
const authenticateToken = require("../middleware/authMiddleware");
const { ObjectId } = require("mongodb");
const PostService = require("./../services/PostService");
const Post = require("../entity/post");

router.put("/like-post", authenticateToken, async function (req, res) {
  const { postId, commentId } = req.body;
  const userId = req.user.userId;

  if (!postId || !userId) {
    return res.status(400).json({ message: "Invalid postId or userId" });
  }

  const likeService = new LikeService();
  const postService = new PostService();
  try {
    const post = await postService.getPost(postId);

    if (!post) {
      return res.status(500).json({ message: "Failed to find the post" });
      
    }

    const like = await likeService.checkIfUserLiked(postId, commentId, userId);
    // console.log("🚀 ~ like:", like);

    const updatedPost = new Post();
    if (like) {
      post.Likes = post.Likes - 1;
      const updatePostResult = await postService.updatePost(post);
      const deleteLikeResult = await likeService.deleteLike(like._id);

      if (
        deleteLikeResult.deletedCount === 1 &&
        updatePostResult.modifiedCount === 1
      ) {
        return res
          .status(200)
          .json({ message: `You unliked the post ${postId}` });
      } else {
        return res.status(500).json({ message: "Failed to unlike the post" });
      }
    } else {
      const newLike = new Like();
      newLike.PostId = new ObjectId(postId);
      newLike.CommentId = commentId;
      newLike.UserId = new ObjectId(userId);

      const insertLikeResult = await likeService.insertLike(newLike);

      post.Likes = post.Likes + 1;
      const updatePostResult = await postService.updatePost(post);

      if (
        insertLikeResult &&
        insertLikeResult.insertedId &&
        updatePostResult.modifiedCount === 1
      ) {
        postService.updatePost(post);
        return res.status(200).json({
          message: "Like successfully",
          likeId: insertLikeResult.insertedId,
        });
      } else {
        return res.status(500).json({ message: "Failed to like the post" });
      }
    }
  } catch (error) {
    console.error("Error when like:", error);
    res.status(500).json({
      message: "Failed to like the post",
      error: error.message,
    });
  }
});

router.post("/check-like", authenticateToken, async function (req, res) {
  const { postId, commentId } = req.body;
  // console.log("🚀 ~  postId, commentId:",  postId, commentId);

  const userId = req.user.userId;

  if (!postId || !userId) {
    return res.status(400).json({ message: "Invalid postId or userId" });
  }

  const likeService = new LikeService();
  try {
    const like = await likeService.checkIfUserLiked(postId, commentId, userId);

    if (like) {
      return res.status(200).json({ isLiked: true });
    } else {
      return res.status(200).json({ isLiked: false });
    }
  } catch (error) {
    console.error("Error when check the like:", error);
    res.status(500).json({
      message: "Failed to check the like",
      error: error.message,
    });
  }
});

module.exports = router;
