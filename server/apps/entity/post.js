class Post {
  _id;
  UserId;
  Content;
  MediaType;
  MediaUrls;
  CreatedAt;
  UpdatedAt;
  Likes;

  constructor() {
    this.MediaUrls = [];
    this.Likes = 0;
    this.CreatedAt = new Date();
    this.UpdatedAt = new Date();
  }
}

module.exports = Post;