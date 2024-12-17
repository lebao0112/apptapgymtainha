// controllers/FoodDiaryController.js
const express = require("express");
const router = express.Router();
const FoodDiaryService = require("../services/FoodDiaryService");
const authenticateToken = require("../middleware/authMiddleware");

// Tạo hoặc cập nhật Food Diary cho người dùng
// Tạo hoặc cập nhật Food Diary cho người dùng
router.post("/create-or-update", authenticateToken, async (req, res) => {
//  const { date, breakfast, lunch, dinner } = req.body.foodItem.date;
  const date = req.body.foodItem.date;
  const breakfast = req.body.foodItem.breakfast;
  const lunch = req.body.foodItem.lunch;
  const dinner = req.body.foodItem.dinner;
  console.log(req.body);
  const userId = req.user.userId;  // Lấy ID người dùng từ token

  console.log(req.user.userId);

  // Kiểm tra tính hợp lệ của ngày
  if (isNaN(new Date(date).getTime())) {
    console.log(new Date());
    return res.status(400).json({ message: "Invalid date format. Please use YYYY-MM-DD." });
  }

  try {
    const foodDiaryService = new FoodDiaryService();
    let foodDiary = await foodDiaryService.getFoodDiaryByDate(userId, date);
    console.log(`${foodDiary}`);  // Sử dụng dấu nháy kép trong log

    if (foodDiary) {
      // Nếu đã có nhật ký cho ngày này, cập nhật các bữa ăn
      foodDiary.breakfast = breakfast;  // Đảm bảo gửi mảng các món ăn
      foodDiary.lunch = lunch;
      foodDiary.dinner = dinner;

      await foodDiaryService.updateFoodDiary(foodDiary);
      return res.status(200).json({ message: "Food diary updated successfully", foodDiary });
    } else {
      // Nếu chưa có nhật ký cho ngày này, tạo mới
      foodDiary = await foodDiaryService.insertFoodDiary({
        userId,
        date: new Date(date),  // Đảm bảo ngày được chuyển thành Date hợp lệ
        breakfast,
        lunch,
        dinner
      });
      return res.status(201).json({ message: "Food diary created successfully", foodDiary });
    }
  } catch (error) {
    console.error("Error creating/updating food diary:", error);
    res.status(500).json({ message: "Error occurred while saving food diary", error: error.message });
  }
});


// Lấy Food Diary của người dùng theo ngày
router.get("/get/:date", authenticateToken, async (req, res) => {
  const { date } = req.params;
  const userId = req.user.userId;  // Lấy ID người dùng từ token

  try {
    const foodDiaryService = new FoodDiaryService();
    const foodDiary = await foodDiaryService.getFoodDiaryByDate(userId, date);

    if (!foodDiary) {
      return res.status(404).json({ message: "Food diary not found for this date" });
    }

    res.status(200).json(foodDiary);
  } catch (error) {
    console.error("Error retrieving food diary:", error);
    res.status(500).json({ message: "Error occurred while retrieving food diary", error: error.message });
  }
});

// Lấy Food Diary của người dùng cho một khoảng thời gian (ví dụ: tuần, tháng)
router.get("/get-range", authenticateToken, async (req, res) => {
  const { startDate, endDate } = req.query;
  const userId = req.user.userId;  // Lấy ID người dùng từ token

  try {
    const foodDiaryService = new FoodDiaryService();
    const foodDiaries = await foodDiaryService.getFoodDiaryByRange(userId, startDate, endDate);

    res.status(200).json(foodDiaries);
  } catch (error) {
    console.error("Error retrieving food diaries by date range:", error);
    res.status(500).json({ message: "Error occurred while retrieving food diaries by date range", error: error.message });
  }
});

// Xóa Food Diary của người dùng theo ngày
router.delete("/delete/:date", authenticateToken, async (req, res) => {
  const { date } = req.params;
  const userId = req.user.userId;  // Lấy ID người dùng từ token

  try {
    const foodDiaryService = new FoodDiaryService();
    const result = await foodDiaryService.deleteFoodDiary(userId, date);

    if (result.deletedCount === 0) {
      return res.status(404).json({ message: "Food diary not found for this date" });
    }

    res.status(200).json({ message: "Food diary deleted successfully" });
  } catch (error) {
    console.error("Error deleting food diary:", error);
    res.status(500).json({ message: "Error occurred while deleting food diary", error: error.message });
  }
});

module.exports = router;
