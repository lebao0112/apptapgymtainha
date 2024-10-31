class Workout {
  _id;
  Title;
  Description;
  Exercises;
  UserId;
  RestTime;
  isAvailable
  constructor() {
    this.Exercises = [];
  }
}

module.exports = Workout;
