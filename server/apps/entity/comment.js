class Comment {
  _id;
  PostId;
  UserId;
  Content;
  ParentId;
  CreatedAt;
  UpdatedAt;

  constructor() {
    this.CreatedAt = new Date();
    this.UpdatedAt = new Date();
  }
}

module.exports = Comment;