import React, { useState } from 'react';
import axios from 'axios';
import DropFileInput from '../../components/DropFileInput';
import { uploadToCloudinary} from '../../config/uploadFileConfig';

 
function AddExerciseModal({ isOpen, onClose, onSave }) {
    const [exerciseName, setExerciseName] = useState('');
    const [exerciseType, setExerciseType] = useState('');
    const [exerciseMuscle, setExerciseMuscle] = useState('');
    const [exerciseEquipment, setExerciseEquipment] = useState('');
    const [exerciseDifficulty, setExerciseDifficulty] = useState('');
    const [exerciseInstructions, setExerciseInstructions] = useState('');
    const [imageFile, setImageFile] = useState(null);
    const [videoFile, setVideoFile] = useState(null);
    const [imageUrl, setImageUrl] = useState("");
    const [videoUrl, setVideoUrl] = useState("");


    const onFileChange = (files) => {
        console.log("🚀 ~ onFileChange ~ files:", files)
        
    }
    const handleImageFileChange = (files) => {
        if (!files) {
            console.error("No image file selected.");
            return;
        }
        console.log("Image file selected:", files);
        setImageFile(files[0]);
    };

    const handleVideoFileChange = (files) => {
        if (!files) {
            console.error("No video file selected.");
            return;
        }
        console.log("Video file selected:", files);
        setVideoFile(files[0]);
    };


    const handleUpload = async (file) => {
        console.log("File to upload:", file); // Debug log to ensure the file is correct
        if (!file) {
            console.error("No file provided for upload.");
            return;
        }

        const result = await uploadToCloudinary(file);
        console.log("Uploaded File URL:", result.secure_url);

        return result;
    };

    const handleSave = async () => {
        if (!exerciseName || !exerciseType || !exerciseMuscle || !exerciseInstructions || !exerciseDifficulty || !exerciseEquipment) {
            alert("Vui lòng nhập đầy đủ các trường bắt buộc.");
            return;
        }

        let uploadedImageUrl = "";
        let uploadedVideoUrl = "";

        // Upload image
        if (imageFile) {
            try {
                const imageUploadResult = await uploadToCloudinary(imageFile, "yrbkawdp");
                uploadedImageUrl = imageUploadResult.secure_url || imageUploadResult.url || "";
                console.log("Uploaded Image URL:", uploadedImageUrl);
            } catch (error) {
                console.error("Error uploading image:", error);
            }
        }

        // Upload video
        if (videoFile) {
            try {
                const videoUploadResult = await uploadToCloudinary(videoFile, "yrbkawdp");
                uploadedVideoUrl = videoUploadResult.secure_url || videoUploadResult.url || "";
                console.log("Uploaded Video URL:", uploadedVideoUrl);
            } catch (error) {
                console.error("Error uploading video:", error);
            }
        }

        const requestBody = {
            name: exerciseName,
            type: exerciseType,
            muscle: exerciseMuscle,
            equipment: exerciseEquipment,
            difficulty: exerciseDifficulty,
            instructions: exerciseInstructions,
            imageUrl: uploadedImageUrl, 
            videoUrl: uploadedVideoUrl,
        };

        console.log("Request Body:", requestBody);

        try {
            const token = localStorage.getItem('token');
            console.log("🚀 ~ handleSave ~ token:", token)

            
            if (!token) {
                alert("Bạn chưa đăng nhập. Vui lòng đăng nhập để thực hiện hành động này.");
                return;
            }

            const response = await axios.post('/api/admin/exercise/insert-exercise', requestBody, {
                headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${token}`,
                },
            });
          
            onSave();
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
                <div className="">
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
                    {/* Image File */}
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Hình ảnh</label>
                    <DropFileInput onFileChange={(files) => handleImageFileChange(files)} accept=".jpg,.jpeg,.png" />

                    {/* Video File */}
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Video</label>
                    <DropFileInput onFileChange={(files) => handleVideoFileChange(files)} accept=".mp4,.mkv" />
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
