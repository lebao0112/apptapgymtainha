import React, { useState, useRef, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Transition from '../utils/Transition';

function DropdownNotifications({
  align
}) {

  const [dropdownOpen, setDropdownOpen] = useState(false);

  const trigger = useRef(null);
  const dropdown = useRef(null);

  // close on click outside
  useEffect(() => {
    const clickHandler = ({ target }) => {
      if (!dropdown.current) return;
      if (!dropdownOpen || dropdown.current.contains(target) || trigger.current.contains(target)) return;
      setDropdownOpen(false);
    };
    document.addEventListener('click', clickHandler);
    return () => document.removeEventListener('click', clickHandler);
  });

  // close if the esc key is pressed
  useEffect(() => {
    const keyHandler = ({ keyCode }) => {
      if (!dropdownOpen || keyCode !== 27) return;
      setDropdownOpen(false);
    };
    document.addEventListener('keydown', keyHandler);
    return () => document.removeEventListener('keydown', keyHandler);
  });

  return (
    <div className="relative inline-flex">
      <button
        ref={trigger}
        className={`w-8 h-8 flex items-center justify-center hover:bg-gray-100 lg:hover:bg-gray-200 dark:hover:bg-gray-700/50 dark:lg:hover:bg-gray-800 rounded-full ${dropdownOpen && 'bg-gray-200 dark:bg-gray-800'}`}
        aria-haspopup="true"
        onClick={() => setDropdownOpen(!dropdownOpen)}
        aria-expanded={dropdownOpen}
      >
        <span className="sr-only">Notifications</span>
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6" width={16}
          height={16}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0" />
        </svg>

        <div className="absolute top-0 right-0 w-2.5 h-2.5 bg-red-500 border-2 border-gray-100 dark:border-gray-900 rounded-full"></div>
      </button>

      <Transition
        className={`origin-top-right z-10 absolute top-full -mr-48 sm:mr-0 min-w-80 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700/60 py-1.5 rounded-lg shadow-lg overflow-hidden mt-1 ${align === 'right' ? 'right-0' : 'left-0'}`}
        show={dropdownOpen}
        enter="transition ease-out duration-200 transform"
        enterStart="opacity-0 -translate-y-2"
        enterEnd="opacity-100 translate-y-0"
        leave="transition ease-out duration-200"
        leaveStart="opacity-100"
        leaveEnd="opacity-0"
      >
        <div
          ref={dropdown}
          onFocus={() => setDropdownOpen(true)}
          onBlur={() => setDropdownOpen(false)}
        >
          <div className="text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase pt-1.5 pb-2 px-4">Notifications</div>
          <ul>
            <li className="border-b border-gray-200 dark:border-gray-700/60 last:border-0">
              <Link
                className="block py-2 px-4 hover:bg-gray-50 dark:hover:bg-gray-700/20"
                to="#0"
                onClick={() => setDropdownOpen(!dropdownOpen)}
              >
                <span className="block text-sm mb-2">📣 <span className="font-medium text-gray-800 dark:text-gray-100">Edit your information in a swipe</span> Sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim.</span>
                <span className="block text-xs font-medium text-gray-400 dark:text-gray-500">Feb 12, 2024</span>
              </Link>
            </li>
            <li className="border-b border-gray-200 dark:border-gray-700/60 last:border-0">
              <Link
                className="block py-2 px-4 hover:bg-gray-50 dark:hover:bg-gray-700/20"
                to="#0"
                onClick={() => setDropdownOpen(!dropdownOpen)}
              >
                <span className="block text-sm mb-2">📣 <span className="font-medium text-gray-800 dark:text-gray-100">Edit your information in a swipe</span> Sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim.</span>
                <span className="block text-xs font-medium text-gray-400 dark:text-gray-500">Feb 9, 2024</span>
              </Link>
            </li>
            <li className="border-b border-gray-200 dark:border-gray-700/60 last:border-0">
              <Link
                className="block py-2 px-4 hover:bg-gray-50 dark:hover:bg-gray-700/20"
                to="#0"
                onClick={() => setDropdownOpen(!dropdownOpen)}
              >
                <span className="block text-sm mb-2">🚀<span className="font-medium text-gray-800 dark:text-gray-100">Say goodbye to paper receipts!</span> Sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim.</span>
                <span className="block text-xs font-medium text-gray-400 dark:text-gray-500">Jan 24, 2024</span>
              </Link>
            </li>
          </ul>
        </div>
      </Transition>
    </div>
  )
}

export default DropdownNotifications;