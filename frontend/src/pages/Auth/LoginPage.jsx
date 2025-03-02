import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from "axios";

const LoginPage = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const navigate = useNavigate();

    const handleLogin = async (e) => {
        e.preventDefault();
        console.log("🚀 ~ LoginPage ~ email:", email)
        console.log("🚀 ~ LoginPage ~ password:", password)
        
        try{
            const response = await axios.post('/api/admin/user/login', {
                Email: email,
                Password: password,
            });

            const { token } = response.data;

            localStorage.setItem('token', token);
            navigate('/notifications', {replace: true});
           
        } catch (error) {
            alert('Email hoặc mật khẩu không chính xác');
        }
    };

    return (
        <div className="flex items-center justify-center min-h-screen bg-gray-100">
            <div className="w-full max-w-md p-8 space-y-8 bg-white rounded-lg shadow-md">
                <div className="flex justify-center">
                    <img src="/src/images/logo.svg" alt="Logo" width={50} height={50} className="fill-orange-500" />
                </div>
                <h2 className="text-2xl font-bold text-center">Đăng nhập</h2>
                <form onSubmit={handleLogin} className="space-y-6">
                    <div>
                        <label className="block mb-1 text-sm font-medium">Email</label>
                        <input
                            type="email"
                            className="w-full p-2 border rounded-lg"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                        />
                    </div>
                    <div>
                        <label className="block mb-1 text-sm font-medium">Mật khẩu</label>
                        <input
                            type="password"
                            className="w-full p-2 border rounded-lg"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                        />
                    </div>
                    <button
                        type="submit"
                        className="w-full p-2 text-white bg-yellow-500 rounded-lg hover:bg-yellow-700"
                    >
                        Đăng nhập
                    </button>
                </form>
            </div>
        </div>
    );
};

export default LoginPage;
