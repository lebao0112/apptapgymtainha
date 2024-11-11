import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { PencilIcon, TrashIcon } from '@heroicons/react/outline';

function ExerciseTable(props) {
  const [exercises, setExercises] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  useEffect(() => {
    // Gọi API khi component được mount
    axios.get('/api/exercise/exercise-list')
      .then(response => {
        setExercises(response.data);
      })
      .catch(error => {
        console.error('Error fetching data:', error);
      });
  }, []);

  const filteredExercises = exercises.filter((exercise) =>
    exercise.name.toLowerCase().includes(props.searchKey.toLowerCase())
  );
  // Tính toán dữ liệu cho trang hiện tại
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = filteredExercises.slice(indexOfFirstItem, indexOfLastItem);

  // Xử lý chuyển trang
  const handleNextPage = () => {
    if (currentPage < Math.ceil(exercises.length / itemsPerPage)) {
      setCurrentPage(currentPage + 1);
    }
  };

  const handlePreviousPage = () => {
    if (currentPage > 1) {
      setCurrentPage(currentPage - 1);
    }
  };

  return (
    <div className="col-span-full xl:col-span-8 bg-white dark:bg-gray-800 shadow-sm rounded-xl">
      <div className="p-3">
        <div className="overflow-x-auto">
          <table className="table-auto w-full dark:text-gray-300">
            <thead className="text-xs uppercase text-gray-400 dark:text-gray-500 bg-gray-50 dark:bg-gray-700 dark:bg-opacity-50 rounded-sm">
              <tr>
                <th className="p-2">Tên động tác</th>
                <th className="p-2">Số lượt tập</th>
                <th className="p-2">Lượt thích</th>
                <th className="p-2">Thao tác</th>
              </tr>
            </thead>
            <tbody className="text-sm font-medium divide-y divide-gray-100 dark:divide-gray-700/60">
              {currentItems.map((exercise, index) => (
                <tr key={exercise._id}>
                  <td className="p-2">
                    <div className="flex items-center">
                      <img src={exercise.imageUrl} alt={exercise.name} className="w-6 h-6 mr-2" />
                      <div className="text-gray-800 dark:text-gray-100">{exercise.name}</div>
                    </div>
                  </td>
                  <td className="p-2"><div className="text-center">123</div></td>
                  <td className="p-2"><div className="text-center text-green-500">1000</div></td>
                  <td className="p-2">
                    <div className="text-center">
                      <div className="flex justify-center space-x-4">
                        <PencilIcon
                          className="w-5 h-5 text-blue-500 cursor-pointer hover:text-blue-700 hover:scale-110 transition transform duration-150"
                        />
                        <TrashIcon
                          className="w-5 h-5 text-red-500 cursor-pointer hover:text-red-700 hover:scale-110 transition transform duration-150"
                        />
                      </div>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {/* Nút phân trang */}
          <div className="flex justify-between items-center mt-4">
            <button
              onClick={handlePreviousPage}
              disabled={currentPage === 1}
              className="px-4 py-2 bg-gray-200 dark:bg-gray-600 text-black dark:text-white  hover:bg-gray-400 hover:dark:bg-gray-400 rounded-lg"
            >
              Trang trước
            </button>
            <span>{currentPage} / {Math.ceil(exercises.length / itemsPerPage)}</span>
            <button
              onClick={handleNextPage}
              disabled={currentPage === Math.ceil(exercises.length / itemsPerPage)}
              className="px-4 py-2 bg-gray-200 dark:bg-gray-600 text-black dark:text-white  hover:bg-gray-400 hover:dark:bg-gray-400 rounded-lg"

            >
              Trang tiếp
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default ExerciseTable;
