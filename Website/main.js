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

    document.getElementById("Hero").style.display = "none";
    document.getElementById("sbtn").innerHTML = "Locate";
    document.getElementById("user").style.display = "block";
    document.getElementById("user").innerHTML = user.email;
    document.getElementById("bar").style.display = "block";
  } else {
    // if(window.location != "index.html"){
    //   window.location = "https://lymperatos.com";
    // }
    document.getElementById("Hero").style.display = "block";
    document.getElementById("sbtn").innerHTML = "Sign Up";
    document.getElementById("bar").style.display = "none";
  }
});


function login(){
  var email = document.getElementById("email");
  var password = document.getElementById("password");

  firebase.auth().signInWithEmailAndPassword(email.value, password.value).catch(function(error) {
    // Handle Errors here.
    var errorCode = error.code;
    var errorMessage = error.message;

        document.getElementById("error").innerHTML = errorMessage;
  });


}

function logout(){
  firebase.auth().signOut()

}
