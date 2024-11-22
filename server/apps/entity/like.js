class Like {
  _id;
  PostId;
  CommentId;
  UserId;
  CreatedAt;
  UpdatedAt;

  constructor() {
    this.CreatedAt = new Date();
    this.UpdatedAt = new Date();
  }
}

module.exports = Like;