const firebaseConfig = {
    apiKey: "AIzaSyBqC6TzoF4xtsQeaCPduIR0J0ygja8Y0_8",
    authDomain: "sharezone-debug.firebaseapp.com",
    databaseURL: "https://sharezone-debug.firebaseio.com",
    projectId: "sharezone-debug",
    storageBucket: "sharezone-debug.appspot.com",
    messagingSenderId: "366164701221",
    appId: "1:366164701221:web:f78c446134ea71e9bfcfcc",
    measurementId: "G-QWDVZ5D2P2"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();
firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL);