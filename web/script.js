import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
    apiKey: "AIzaSyCTUAfmSX1NMYr051PvEglm-Fznv1Q8r6U",
    authDomain: "white-label-cca4f.firebaseapp.com",
    projectId: "white-label-cca4f",
    storageBucket: "white-label-cca4f.appspot.com",
    messagingSenderId: "344629308261",
    appId: "1:344629308261:web:78a4f664a759b5e7b20f8c",
    measurementId: "G-26540K7KR9"
};

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);