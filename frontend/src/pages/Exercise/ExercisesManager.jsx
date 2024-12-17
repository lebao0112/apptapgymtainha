import React, { useState } from 'react';

import FilterButton from '../../components/DropdownFilter';
import Datepicker from '../../components/Datepicker';
import AddExerciseModal from './AddExerciseModal';
import ExercisesTable from './ExercisesTable';


function ExercisesManager() {

    const [sidebarOpen, setSidebarOpen] = useState(false);
    const [searchKey, setSearchKey] = useState('');
    const [isModalOpen, setIsModalOpen] = useState(false);

    const handleSearchChange = (event) => {
        setSearchKey(event.target.value); // Cập nhật state khi người dùng nhập
    };

    const handleAddButtonClick = () => {
        setIsModalOpen(true); // Mở modal khi nhấn Add
    };

    const handleCloseModal = () => {
        setIsModalOpen(false); // Đóng modal
    };

    const handleSaveExercise = () => {
        // Thực hiện logic lưu bài tập mới
      
        setIsModalOpen(false);
        window.location.reload();
        alert("Đã lưu động tác mới");
    };

    return (

        <div className="px-4 sm:px-6 lg:px-8 py-8 w-full max-w-9xl mx-auto">

            {/* Dashboard actions */}
            <div className="sm:flex sm:justify-between sm:items-center mb-3">

                {/* Left: Title */}
                <div className="mb-4 sm:mb-0">
                    <h1 className="text-2xl md:text-3xl text-gray-800 dark:text-gray-100 font-bold">Danh sách động tác</h1>
                </div>

                {/* Right: Actions */}
                <div className="grid grid-flow-col sm:auto-cols-max justify-start sm:justify-end gap-2">
                    {/* Filter button */}
                    <FilterButton align="right" />
                    {/* Datepicker built with flatpickr */}
                    <Datepicker align="right" />
                    {/* Add button */}
                    <button
                        onClick={handleAddButtonClick} // Bắt sự kiện mở modal
                        className="btn bg-gray-900 text-gray-100 hover:bg-gray-800 dark:bg-gray-100 dark:text-gray-800 dark:hover:bg-white"
                    >
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                        </svg>
                    </button>
                </div>

            </div>
            <div className="relative">
                <span className="absolute inset-y-0 left-0 flex items-center pl-3 mb-3">
                    <svg className="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-4.35-4.35m-5.65 1.35a7 7 0 100-14 7 7 0 000 14z" />
                    </svg>
                </span>
                <input
                    type="text"
                    value={searchKey}
                    onChange={handleSearchChange} // Bắt sự kiện onChange
                    placeholder="Tìm kiếm..."
                    className="w-full pl-10 pr-4 py-2 mb-3 border border-gray-300 rounded-md focus:outline-none"
                />
            </div>

            {/* Cards */}
            <div className="">
                <ExercisesTable searchKey={searchKey} />
            </div>
            <AddExerciseModal
                isOpen={isModalOpen}
                onClose={handleCloseModal}
                onSave={handleSaveExercise}
            />
        </div>
    );
}

export default ExercisesManager;