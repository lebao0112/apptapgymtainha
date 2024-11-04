class History {
  _id;
  UserId;
  WorkoutName;
  WorkoutId;
  Date;
  TotalTime;
  Calories;

  constructor(userId, workoutName, workoutId, date, totalTime, calories) {
    this.UserId = userId;
    this.WorkoutName = workoutName;
    this.WorkoutId = workoutId;
    this.Date = date;
    this.TotalTime = totalTime;
    this.Calories = calories;
  }
}

module.exports = History;
