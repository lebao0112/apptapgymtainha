class User {
  _id;
  Name;
  Email;
  Password;
  Height;
  Weight;
  WorkoutHistory;
  DateOfBirth;
  AvatarUrl;
  Gender;
  constructor() {
    this.WorkoutHistory = [];
  }
}
module.exports = User;
