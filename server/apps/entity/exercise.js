class Exercise {
  _id;
  name;           // Tên bài tập
  type;           // Loại bài tập (ví dụ: strength, cardio)
  muscle;         // Nhóm cơ được tác động
  equipment;      // Dụng cụ sử dụng (ví dụ: dumbbell, barbell)
  difficulty;     // Độ khó (beginner, intermediate, advanced)
  instructions;   // Hướng dẫn thực hiện bài tập
  imageUrl;       // URL hình ảnh minh họa
  videoUrl;       // URL video bài tập


  constructor() {}
}

module.exports = Exercise;
