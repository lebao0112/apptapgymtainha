class Challenge {
  _id;
  Name;
  Description;
  ImageUrl;
  Days;

  constructor() {
    this.Days = [];
  }

  adDay(day) {
    this.Days.push(day);
  }
}
module.exports = Challenge;
