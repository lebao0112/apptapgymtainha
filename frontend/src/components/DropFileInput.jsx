import React, { useRef, useState } from 'react';
import PropTypes from 'prop-types';

import '../css/drop-file-input.css';

import { ImageConfig } from '../config/ImageConfig';
import uploadImg from '../assets/cloud-upload-regular-240.png';

function DropFileInput(props) {

    const wrapperRef = useRef(null);

    const [fileList, setFileList] = useState([]);

    const allowedTypes = props.accept.split(',').map((type) => type.trim());

    const onDragEnter = () => wrapperRef.current.classList.add('dragover');

    const onDragLeave = () => wrapperRef.current.classList.remove('dragover');

    const onDrop = () => wrapperRef.current.classList.remove('dragover');

    const onFileDrop = (e) => {
        const newFile = e.target.files[0];
        console.log("🚀 ~ onFileDrop ~ newFile:", newFile)
        if (newFile) {
            const fileExtension = newFile.name.split('.').pop().toLowerCase();
            const mimeType = newFile.type;

            const isValid =
                allowedTypes.includes(`.${fileExtension}`) ||
                allowedTypes.includes(mimeType);
            if(isValid){
                const updatedList = [...fileList,
                    {
                        file: newFile,
                        preview: URL.createObjectURL(newFile), // Tạo URL preview
                    },
                ];
                console.log("🚀 ~ onFileDrop ~ updatedList:", updatedList)
                
                setFileList(updatedList);
                props.onFileChange([newFile]);
            }else{
                alert(`File không hợp lệ`);
            }
          
        }
    }

    const fileRemove = (file) => {
        const updatedList = [...fileList];
        updatedList.splice(fileList.indexOf(file), 1);
        setFileList(updatedList);
        props.onFileChange(updatedList);
    }

    return (
        <>
            {
                fileList.length > 0 ? (
                    <div className="drop-file-preview">
                        {
                            fileList.map((item, index) => (
                                <div key={index} className="drop-file-preview__item">
                                    {item.file.type.startsWith('image/') ? (
                                        <img
                                            src={item.preview}
                                            alt="Preview"
                                            className="drop-file-preview__image"
                                        />
                                    ) : (
                                        <img
                                            src={ImageConfig[item.file.type.split('/')[1]] || ImageConfig['default']}
                                            alt=""
                                        />
                                    )}
                                    <div className="drop-file-preview__item__info">
                                        <p>{item.file.name}</p>
                                        <p>{item.file.size}B</p>
                                    </div>
                                    <span
                                        className="drop-file-preview__item__del"
                                        onClick={() => fileRemove(item.file)}
                                    >
                                        x
                                    </span>
                                </div>
                            ))
                        }
                    </div>
                ) : (
                    <div
                        ref={wrapperRef}
                        className="drop-file-input"
                        onDragEnter={onDragEnter}
                        onDragLeave={onDragLeave}
                        onDrop={onDrop}
                    >
                        <div className="drop-file-input__label">
                            <div className="flex items-center gap-1">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
                                    <path strokeLinecap="round" strokeLinejoin="round" d="M12 16.5V9.75m0 0 3 3m-3-3-3 3M6.75 19.5a4.5 4.5 0 0 1-1.41-8.775 5.25 5.25 0 0 1 10.233-2.33 3 3 0 0 1 3.758 3.848A3.752 3.752 0 0 1 18 19.5H6.75Z" />
                                </svg>
                                <p className="text-sm">Kéo thả file vào đây</p>
                            </div>

                        </div>
                            <input type="file" accept={props.accept} value="" onChange={onFileDrop} />
                    </div>
                )
            }
        </>
    );
}

DropFileInput.propTypes = {
    onFileChange: PropTypes.func
}

export default DropFileInput;