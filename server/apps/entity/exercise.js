class Exercise {
  _id;
  name;
  type;
  muscle;
  equipment;
  difficulty;
  instructions;
  imageUrl;
  videoUrl;
  isRep;
  createdAt;
  updatedAt;

  constructor() {
    this.createdAt = new Date();
    this.updatedAt = new Date();
  }
}

module.exports = Exercise;
