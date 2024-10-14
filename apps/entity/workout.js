class Workout {
  _id;
  Title;
  Description;
  Exercises;
  UserId; // This will store the ID of the user who created the workout

  constructor() {
    this.Exercises = [];
  }
}
module.exports = Workout;
