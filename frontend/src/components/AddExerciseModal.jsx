import React, { useState } from 'react';
import axios from 'axios';

function AddExerciseModal({ isOpen, onClose, onSave }) {
    // Các state lưu trữ thông tin động tác
    const [exerciseName, setExerciseName] = useState('');
    const [exerciseType, setExerciseType] = useState('');
    const [exerciseMuscle, setExerciseMuscle] = useState('');
    const [exerciseEquipment, setExerciseEquipment] = useState('');
    const [exerciseDifficulty, setExerciseDifficulty] = useState('');
    const [exerciseInstructions, setExerciseInstructions] = useState('');

    if (!isOpen) return null; // Nếu modal không mở, không render gì cả

    const handleSave = async () => {
        // Tạo một đối tượng chứa thông tin động tác từ các state
        const newExercise = {
            name: exerciseName,
            type: exerciseType,
            muscle: exerciseMuscle,
            equipment: exerciseEquipment,
            difficulty: exerciseDifficulty,
            instructions: exerciseInstructions,
        };

        try {
            // Gọi API để thêm mới động tác
            const response = await axios.post('/api/exercise/insert-exercise', newExercise);
            console.log("Exercise added:", response.data);

            // Gọi hàm onSave từ props để cập nhật UI sau khi lưu
            onSave(response.data);
            onClose(); // Đóng modal sau khi lưu thành công
        } catch (error) {
            console.error("Error adding exercise:", error);
            alert("Failed to add exercise");
        }
    };

    return (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={onClose}>
            <div
                className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-lg max-w-lg w-full relative"
                onClick={(e) => e.stopPropagation()} // Ngăn sự kiện click ra ngoài
            >
                <h2 className="text-xl font-semibold mb-4">Thêm động tác mới</h2>
                <input
                    type="text"
                    placeholder="Tên động tác"
                    value={exerciseName}
                    onChange={(e) => setExerciseName(e.target.value)}
                    className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
                />
                <input
                    type="text"
                    placeholder="Loại"
                    value={exerciseType}
                    onChange={(e) => setExerciseType(e.target.value)}
                    className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
                />
                <input
                    type="text"
                    placeholder="Nhóm cơ"
                    value={exerciseMuscle}
                    onChange={(e) => setExerciseMuscle(e.target.value)}
                    className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
                />
                <input
                    type="text"
                    placeholder="Dụng cụ"
                    value={exerciseEquipment}
                    onChange={(e) => setExerciseEquipment(e.target.value)}
                    className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
                />
                <input
                    type="text"
                    placeholder="Độ khó"
                    value={exerciseDifficulty}
                    onChange={(e) => setExerciseDifficulty(e.target.value)}
                    className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
                />
                <textarea
                    placeholder="Hướng dẫn"
                    value={exerciseInstructions}
                    onChange={(e) => setExerciseInstructions(e.target.value)}
                    className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
                />
                <div className="flex justify-end mt-4">
                    <button
                        onClick={onClose}
                        className="mr-2 px-4 py-2 bg-gray-300 rounded-md hover:bg-gray-400"
                    >
                        Đóng
                    </button>
                    <button
                        onClick={handleSave}
                        className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                    >
                        Lưu
                    </button>
                </div>
            </div>
        </div>
    );
}

export default AddExerciseModal;
