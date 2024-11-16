// import React, { useState } from 'react';
// import axios from 'axios';

// function AddExerciseModal({ isOpen, onClose, onSave }) {
//     // Các state lưu trữ thông tin động tác
//     const [exerciseName, setExerciseName] = useState('');
//     const [exerciseType, setExerciseType] = useState('');
//     const [exerciseMuscle, setExerciseMuscle] = useState('');
//     const [exerciseEquipment, setExerciseEquipment] = useState('');
//     const [exerciseDifficulty, setExerciseDifficulty] = useState('');
//     const [exerciseInstructions, setExerciseInstructions] = useState('');

//     if (!isOpen) return null; // Nếu modal không mở, không render gì cả

//     const handleSave = async () => {
//         // Tạo một đối tượng chứa thông tin động tác từ các state
//         const newExercise = {
//             name: exerciseName,
//             type: exerciseType,
//             muscle: exerciseMuscle,
//             equipment: exerciseEquipment,
//             difficulty: exerciseDifficulty,
//             instructions: exerciseInstructions,
//         };

//         try {
//             // Gọi API để thêm mới động tác
//             const response = await axios.post('/api/exercise/insert-exercise', newExercise);
//             console.log("Exercise added:", response.data);

//             // Gọi hàm onSave từ props để cập nhật UI sau khi lưu
//             onSave(response.data);
//             onClose(); // Đóng modal sau khi lưu thành công
//         } catch (error) {
//             console.error("Error adding exercise:", error);
//             alert("Failed to add exercise");
//         }
//     };

//     return (
//         <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={onClose}>
//             <div
//                 className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-lg max-w-lg w-full relative"
//                 onClick={(e) => e.stopPropagation()} // Ngăn sự kiện click ra ngoài
//             >
//                 <h2 className="text-xl font-semibold mb-4">Thêm động tác mới</h2>
//                 <input
//                     type="text"
//                     placeholder="Tên động tác"
//                     value={exerciseName}
//                     onChange={(e) => setExerciseName(e.target.value)}
//                     className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
//                 />
//                 <input
//                     type="text"
//                     placeholder="Loại"
//                     value={exerciseType}
//                     onChange={(e) => setExerciseType(e.target.value)}
//                     className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
//                 />
//                 <input
//                     type="text"
//                     placeholder="Nhóm cơ"
//                     value={exerciseMuscle}
//                     onChange={(e) => setExerciseMuscle(e.target.value)}
//                     className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
//                 />
//                 <input
//                     type="text"
//                     placeholder="Dụng cụ"
//                     value={exerciseEquipment}
//                     onChange={(e) => setExerciseEquipment(e.target.value)}
//                     className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
//                 />
//                 <input
//                     type="text"
//                     placeholder="Độ khó"
//                     value={exerciseDifficulty}
//                     onChange={(e) => setExerciseDifficulty(e.target.value)}
//                     className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
//                 />
//                 <textarea
//                     placeholder="Hướng dẫn"
//                     value={exerciseInstructions}
//                     onChange={(e) => setExerciseInstructions(e.target.value)}
//                     className="w-full mb-3 p-2 border border-gray-300 rounded-md focus:outline-none"
//                 />
//                 <div className="flex justify-end mt-4">
//                     <button
//                         onClick={onClose}
//                         className="mr-2 px-4 py-2 bg-gray-300 rounded-md hover:bg-gray-400"
//                     >
//                         Đóng
//                     </button>
//                     <button
//                         onClick={handleSave}
//                         className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
//                     >
//                         Lưu
//                     </button>
//                 </div>
//             </div>
//         </div>
//     );
// }

// export default AddExerciseModal;

import React, { useState } from 'react';
import axios from 'axios';
import DropFileInput from '../../components/DropFileInput';

function AddExerciseModal({ isOpen, onClose, onUpdateList }) {
    const [exerciseName, setExerciseName] = useState('');
    const [exerciseType, setExerciseType] = useState('');
    const [exerciseMuscle, setExerciseMuscle] = useState('');
    const [exerciseEquipment, setExerciseEquipment] = useState('');
    const [exerciseDifficulty, setExerciseDifficulty] = useState('');
    const [exerciseInstructions, setExerciseInstructions] = useState('');
    const [imageFile, setImageFile] = useState(null);
    const [videoFile, setVideoFile] = useState(null);
    const [imagePreview, setImagePreview] = useState(null);
    const [videoPreview, setVideoPreview] = useState(null);

    const onFileChange = (files) => {
        console.log(files);
    }

    const handleFileDrop = (event, setFile) => {
        event.preventDefault();
        const file = event.dataTransfer.files[0];
        setFile(file);
        setPreview(URL.createObjectURL(file));
    };

    const handleFileChange = (event, setFile) => {
        const file = event.target.files[0];
        setFile(file);
        setPreview(URL.createObjectURL(file));
    };

    const handleSave = async () => {
        if (!exerciseName || !exerciseType || !exerciseInstructions) {
            alert("Vui lòng nhập đầy đủ các trường bắt buộc.");
            return;
        }

        const formData = new FormData();
        formData.append('name', exerciseName);
        formData.append('type', exerciseType);
        formData.append('muscle', exerciseMuscle);
        formData.append('equipment', exerciseEquipment);
        formData.append('difficulty', exerciseDifficulty);
        formData.append('instructions', exerciseInstructions);
        if (imageFile) formData.append('image', imageFile);
        if (videoFile) formData.append('video', videoFile);

        try {
            await axios.post('/api/exercise/insert-exercise', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            });
            const response = await axios.get('/api/admin/exercise/exercise-list');
            onUpdateList(response.data);
            onClose();
        } catch (error) {
            console.error("Error adding exercise:", error);
            alert("Thêm động tác thất bại.");
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={onClose}>
            <div
                className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-lg w-full max-h-[80vh] max-w-[100vh] overflow-y-auto relative"
                onClick={(e) => e.stopPropagation()}
            >
                <h2 className="text-xl font-semibold mb-4">Thêm động tác mới</h2>
                <div className="flex gap-10 justify-start">
                    <div>
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tên động tác *</label>
                        <input
                            type="text"
                            value={exerciseName}
                            onChange={(e) => setExerciseName(e.target.value)}
                            className="w-full mb-4 p-2 border border-gray-300 rounded-md focus:outline-none"
                        />

                        {/* Type */}
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Loại *</label>
                        <input
                            type="text"
                            value={exerciseType}
                            onChange={(e) => setExerciseType(e.target.value)}
                            className="w-full mb-4 p-2 border border-gray-300 rounded-md focus:outline-none"
                        />

                        {/* Muscle */}
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Nhóm cơ</label>
                        <input
                            type="text"
                            value={exerciseMuscle}
                            onChange={(e) => setExerciseMuscle(e.target.value)}
                            className="w-full mb-4 p-2 border border-gray-300 rounded-md focus:outline-none"
                        />

                        {/* Equipment */}
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Dụng cụ</label>
                        <input
                            type="text"
                            value={exerciseEquipment}
                            onChange={(e) => setExerciseEquipment(e.target.value)}
                            className="w-full mb-4 p-2 border border-gray-300 rounded-md focus:outline-none"
                        />

                        {/* Difficulty */}
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Độ khó</label>
                        <input
                            type="text"
                            value={exerciseDifficulty}
                            onChange={(e) => setExerciseDifficulty(e.target.value)}
                            className="w-full mb-4 p-2 border border-gray-300 rounded-md focus:outline-none"
                        />

                        {/* Instructions */}
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Hướng dẫn *</label>
                        <textarea
                            value={exerciseInstructions}
                            onChange={(e) => setExerciseInstructions(e.target.value)}
                            className="w-full mb-4 p-2 border border-gray-300 rounded-md focus:outline-none"
                        ></textarea>
                    </div>
                    <div>
                        {/* Image File */}
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Hình ảnh</label>
                        <DropFileInput onFileChange={(files) => onFileChange(files)} />

                        {/* Video File */}
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Video</label>
                        <div
                            onDragOver={(e) => e.preventDefault()}
                            onDrop={(e) => handleFileDrop(e, setVideoFile, setVideoPreview)}
                            className="w-full p-4 border border-dashed border-gray-300 rounded-md text-center mb-4"
                        >
                            {videoPreview ? (
                                <video src={videoPreview} controls className="w-full h-32 rounded-md" />
                                
                            ) : (
                                "Kéo thả hoặc chọn file video"
                            )}
                            
                            <input
                                type="file"
                                accept="video/*"
                                onChange={(e) => handleFileChange(e, setVideoFile, setVideoPreview)}
                                className="hidden"
                            />
                        </div>

                    </div>
                </div>
                

                {/* Buttons */}
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
