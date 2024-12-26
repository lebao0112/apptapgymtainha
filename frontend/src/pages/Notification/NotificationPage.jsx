import React, { useState } from 'react';
import axios from 'axios';
import DropFileInput from "../../components/DropFileInput";
import { uploadToCloudinary } from '../../config/uploadFileConfig';

const SendNotificationPage = () => {
    const [formData, setFormData] = useState({
        title: '',
        content: '',
        icon: 'https://apptapgymtainha.s3.ap-southeast-2.amazonaws.com/app-icon/logo_app.png',
        imageUrl: '',
    });

    const [responseMessage, setResponseMessage] = useState('');
    const [selectedFile, setSelectedFile] = useState(null);
    const [isSubmitting, setIsSubmitting] = useState(false);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prevData) => ({
            ...prevData,
            [name]: value,
        }));
    };

    const handleFileChange = (files) => {
        if (files.length > 0) {
            setSelectedFile(files[0]); // Lưu file vào state
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        setIsSubmitting(true);

        try {
            const token = localStorage.getItem('token');
            console.log("🚀 ~ handleSave ~ token:", token)

            if (!token) {
                alert("Bạn chưa đăng nhập. Vui lòng đăng nhập để thực hiện hành động này.");
                return;
            }

            let imageUrl = formData.imageUrl;
            if (selectedFile) {
                const uploadedFile = await uploadToCloudinary(selectedFile, "xmgjxuac");
                imageUrl = uploadedFile.secure_url;
            }

            const notificationData = {
                ...formData,
                imageUrl,
            };
            console.log("🚀 ~ handleSubmit ~ ta:", notificationData)
            
            const response = await axios.post('api/admin/notification/send', notificationData, {
                headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${token}`,
                },
            });

            setResponseMessage(response.data || 'Notification sent successfully!');
        } catch (error) {
            setResponseMessage(
                error.response?.data || `Lỗi: ${error}`
            );
        } finally {
            setIsSubmitting(false);
        }
        
    };

    return (
        <div className="max-w-xl mx-auto p-4">
            <h1 className="text-2xl font-bold mb-4">Gửi thông báo</h1>
            <form onSubmit={handleSubmit} className="space-y-4">
                {/* Title Field */}
                <div>
                    <label className="block text-sm font-medium mb-1">Tiêu đề</label>
                    <input
                        type="text"
                        name="title"
                        value={formData.title}
                        onChange={handleChange}
                        placeholder="Enter notification title"
                        className="w-full border rounded p-2"
                        required
                    />
                </div>

                {/* Content Field */}
                <div>
                    <label className="block text-sm font-medium mb-1">Nội dung</label>
                    <textarea
                        name="content"
                        value={formData.content}
                        onChange={handleChange}
                        placeholder="Enter notification content"
                        className="w-full border rounded p-2"
                        rows="4"
                        required
                    />
                </div>

                {/* Icon Field
                  <div>
                    <label className="block text-sm font-medium mb-1">Đường dẫn icon</label>
                    <input
                        type="text"
                        name="icon"
                        value={formData.icon}
                        onChange={handleChange}
                        placeholder="Enter icon URL"
                        className="w-full border rounded p-2"
                    />
                </div> */}
              

                {/* Image URL Field */}
                {/* <div>
                    <label className="block text-sm font-medium mb-1">Đường dẫn ảnh </label>
                    <input
                        type="text"
                        name="imageUrl"
                        value={formData.imageUrl}
                        onChange={handleChange}
                        placeholder="Enter image URL"
                        className="w-full border rounded p-2"
                    />
                </div> */}
               

                <div>
                    <label className="block text-sm font-medium mb-1">Hình ảnh</label>
                    <DropFileInput onFileChange={handleFileChange} accept=".jpg,.jpeg,.png"/>
                    {selectedFile && (
                        <p className="mt-2">Các file: {selectedFile.name}</p>
                    )}
                </div>


                {/* Submit Button */}
                <div>
                    <button
                        type="submit"
                        className="w-full bg-orange-500 text-white font-medium py-2 rounded hover:bg-orange-600"
                    >
                        Gửi thông báo
                    </button>
                </div>
            </form>

            {/* Response Message */}
            {responseMessage && (
                <div className="mt-4 text-center">
                    <p>{responseMessage}</p>
                </div>
            )}
        </div>
    );
};

export default SendNotificationPage;
