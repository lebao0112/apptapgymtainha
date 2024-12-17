// models/FoodDiary.js

class FoodDiary {
  _id;            // ID của FoodDiary (MongoDB sẽ tự sinh tự động)
  userId;         // ID của người dùng (Liên kết với bảng User)
  date;           // Ngày ghi nhật ký
  breakfast;      // Mảng chứa thông tin món ăn buổi sáng (Mỗi món sẽ có tên và calo)
  lunch;          // Mảng chứa thông tin món ăn buổi trưa (Mỗi món sẽ có tên và calo)
  dinner;         // Mảng chứa thông tin món ăn buổi tối (Mỗi món sẽ có tên và calo)

  constructor(date, userId) {
    this.date = date;
    this.userId = userId;
    this.breakfast = [];
    this.lunch = [];
    this.dinner = [];
  }

}

module.exports = FoodDiary;
