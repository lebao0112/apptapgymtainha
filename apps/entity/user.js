class User {
  _id;
  Name;
  Email;
  Password;
  Height;
  Weight;
  WorkoutHistory;

  constructor() {
    this.WorkoutHistory = [];
  }
}
module.exports = User;
