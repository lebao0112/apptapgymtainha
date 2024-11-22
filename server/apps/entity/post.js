class Post {
  _id;
  UserId;
  Content;
  MediaType;
  MediaUrls;
  CreatedAt;
  UpdatedAt;

  constructor() {
     this.MediaUrls = [];
    this.CreatedAt = new Date();
    this.UpdatedAt = new Date();
  }
}

module.exports = Post;