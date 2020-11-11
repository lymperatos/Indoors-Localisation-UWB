// Your web app's Firebase configuration
var firebaseConfig = {
  apiKey: "AIzaSyAh7HynbvM9trAsJvMDBSx9Ghnyj3-ig9s",
  authDomain: "localisation-7bdfa.firebaseapp.com",
  databaseURL: "https://localisation-7bdfa.firebaseio.com",
  projectId: "localisation-7bdfa",
  storageBucket: "localisation-7bdfa.appspot.com",
  messagingSenderId: "303751994749",
  appId: "1:303751994749:web:676f4b1f5233b913198014"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);


const auth = firebase.auth();

firebase.auth().onAuthStateChanged(function(user) {
  if (user) {

    window.location = "https://lymperatos.com/Website/locate.html";//TODO: FIX THIS

  } else {

      window.location = "https://lymperatos.com";

  }
});


function login(){
  var email = document.getElementById("email");
  var password = document.getElementById("password");

  firebase.auth().signInWithEmailAndPassword(email.value, password.value).catch(function(error) {
    // Handle Errors here.
    var errorCode = error.code;
    var errorMessage = error.message;

    alert("Error" + errorMessage);
  });


}
