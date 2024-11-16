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
  Role;
  constructor() {
    this.WorkoutHistory = [];
  }
}
module.exports = User;
