class Workout {
  _id;
  Title;
  Description;
  Exercises;
  UserId;
  RestTime;
  constructor() {
    this.Exercises = [];
  }

  addExercise(exerciseName, reps, sets, duration) {
    this.Exercises.push({
      exerciseName,
      reps,
      sets,
      duration,
    });
  }
}

module.exports = Workout;
