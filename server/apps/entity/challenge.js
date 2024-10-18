class Challenge {
  _id;
  Name;
  Description;
  ImageUrl;
  Days;

  constructor() {
    this.Days = [];
  }

  addDay(day, workout) {
    this.Days.push({ day, workout });
  }
}

module.exports = Challenge;
