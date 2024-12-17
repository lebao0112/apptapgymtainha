class FriendShip {
  _id;
  UserId1;
  UserId2;
  CreatedAt;
  UpdatedAt;

  constructor() {
    this.CreatedAt = new Date();
    this.UpdatedAt = new Date();
  }
}

module.exports = FriendShip;