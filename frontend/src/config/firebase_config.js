// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCiw2eZ5bG_PfJ7hAf8otnEVLTcJvc8I2I",
  authDomain: "apptapgymtainha-65644.firebaseapp.com",
  projectId: "apptapgymtainha-65644",
  storageBucket: "apptapgymtainha-65644.firebasestorage.app",
  messagingSenderId: "236578415926",
  appId: "1:236578415926:web:76883e5ffd23635df97f97",
  measurementId: "G-QB9EDYHJQJ",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
