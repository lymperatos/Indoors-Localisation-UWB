
var zoom = 80;
let ainfoArray = [];
var addingAnchor = false;
var aId = "";
var x = document.getElementById("body").offsetWidth-300;
var y = document.getElementById("body").clientHeight;
var tagx = 0;
var tagy = 0;
/* Map of room parameters */
var w = 300; // Default width of map
var h = 200; // Default height of map


//Firebase configuration
var firebaseConfig = {
  apiKey: "AIzaSyAh7HynbvM9trAsJvMDBSx9Ghnyj3-ig9s",
  authDomain: "localisation-7bdfa.firebaseapp.com",
  databaseURL: "https://localisation-7bdfa.firebaseio.com",
  projectId: "localisation-7bdfa",
  storageBucket: "localisation-7bdfa.appspot.com",
  messagingSenderId: "303751994749",
  appId: "1:303751994749:web:676f4b1f5233b913198014"
};


/* Firebase parameters */
firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();
var database = firebase.database();
var  userId;
//  userId = firebase.auth().currentUser.uid;


firebase.auth().onAuthStateChanged(function(user) {

  if (user) {

    userId = user.uid;
    console.log("ID: "+userId);
    document.getElementById("Hero").style.display = "none";
    document.getElementById("footer-main").style.display = "none";
    document.getElementById("user").style.display = "block";
    document.getElementById("user").innerHTML = user.email;
    document.getElementById("bar").style.display = "block";
    document.getElementById("dashboard").style.display = "block";
    document.getElementById("map").style.display = "block";
    //document.querySelectorAll("canvas").style.display = "block";


     downloadMap(userId);
     downloadAnchors(userId);
     downloadTag(userId);


  } else {
    // if(window.location != "index.html"){
    //   window.location = "https://lymperatos.com";
    // }
    document.getElementById("Hero").style.display = "block";
    document.getElementById("bar").style.display = "none";
    document.getElementById("footer-main").style.display = "block";
    document.getElementById("dashboard").style.display = "none";
    document.getElementById("map").style.display = "none";
  //  document.querySelectorAll("canvas").style.display = "none";
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

function signUp(){
  var email = document.getElementById("email").value;
  var password = document.getElementById("password").value;

  firebase.auth().createUserWithEmailAndPassword(email, password)
    .then((user) => {
        document.getElementById("error").innerHTML = "Welcome! " + email;
    })
    .catch((error) => {
      var errorCode = error.code;
      var errorMessage = error.message;

    });


  var errorCode = error.code;
  var errorMessage = error.message;
      document.getElementById("error").innerHTML = errorMessage;
}

function logout(){
  firebase.auth().signOut()
}


function setup() {

    background(255);
   //createCanvas(windowWidth-320, windowHeight);
   let canvas = createCanvas(w, h);


   canvas.position(200,300);
   canvas.id('map');


  //    var userId = firebase.auth().currentUser.uid;
}


function draw() {

  background(255);    //clears previous frame

  drawGrid(w,h);    //redrawing grid frame
  ainfoArray.forEach(anchor => {

    stroke(252, 147, 10);
    strokeWeight(2);
    line(anchor[1]*zoom, anchor[2]*zoom, tagx*zoom, tagy*zoom);
    noStroke();
    strokeWeight(1);

    drawAnchor(anchor[1], anchor[2], anchor[0]);

  });
  drawTag(tagx, tagy);
  // tagx =mouseX/zoom;
  // tagy = mouseY/zoom;



  // firebase.database().ref().child("/Tag").once('value').then((snapshot) => {
  //         tagx = snapshot.val().A1;
  //
  //       drawTag(referenceX+ax*zoom,referenceY+ay*zoom+snapshot.val().A1*zoom);
  //          setLocationAn.play();
  //
  //  });


}

function mousePressed() {
  //ellipse(mouseX, mouseY, 5, 5);

  if(addingAnchor){
  ainfoArray = [];
  uploadAnchor(userId, aId,mouseX,mouseY);
  downloadAnchors(userId);
  addingAnchor = false;
  }


}

function drawGrid(width,height){
  stroke(200);
    for (var i = 0; i < width; i += 10) {

        line(i, 0, i, height);
        line(width, i, 0, i);
      }
}

/* Uploading Map width and height to firebase */
var uploadMap = function (userId, w, h) {
  firebase.database().ref('users/' + userId + "/map").set({
    width: w,
    height: h
  });
}
/* Uploading Anchor to firebase */
var uploadAnchor = function (userId, aid, x, y) {
  firebase.database().ref('users/' + userId + "/Devices/Anchor " + aid).set({
    x: (x)/zoom,
    y: (y)/zoom
  });
  drawGrid(x,y, "canvas");
}
/* Downloading Map's width and height from firebase */
var downloadMap = function(userId){

  firebase.database().ref().child('users/' + userId + "/map")
      .once('value')
      .then((snapshot) => {
          const w = snapshot.val().width;
          const h = snapshot.val().height;
          setMap(w, h);

      });
}
/* Downloading Anchors from firebase */
var downloadAnchors = function(userId){
  firebase.database().ref().child('users/' + userId + "/Devices")
      .once('value')
      .then((snapshot) => {

        snapshot.forEach(function(child) {
          ainfoArray.push([child.key ,child.val().x,child.val().y]);
          //drawAnchor(child.val().x*zoom,child.val().y*zoom, child.key);
        });

        setAnchorsInfo();
      });
}
/* Downloading Tag from firebase */
var downloadTag = function(userId){
  firebase.database().ref().child('users/' + userId + "/Tag")
      .on('value', function(snapshot) {
    console.log(snapshot.val().x,snapshot.val().y);
    tagx =snapshot.val().x;
    tagy = snapshot.val().y;
  });

}

/* Set Map using width and height as parameters */
var setMap = function(w, h){
  resizeCanvas(w* zoom, h* zoom);
  this.h= h*zoom;
  this.w= w*zoom;
  console.log(w+","+h)
}
/* Save Map */
var saveMap = function(){
  w = document.getElementById("map-width").value * zoom;
  h = document.getElementById("map-height").value * zoom;
  resizeCanvas(w, h);
  emp.style.display = "none";
  uploadMap(userId, w/zoom,h/zoom);
}

var getMap = function(){
  var w,h;
}
/* Draw Anchors */
var drawAnchor = function(x, y, name){

    noStroke();
    fill(93, 151, 255, 100);
    ellipse(x*zoom, y*zoom, 30, 30);
    fill(93, 151, 255, 255);
    ellipse(x*zoom, y*zoom, 15, 15);
    textSize(18);
    text(name, x*zoom+10, y*zoom-10);

}
/* Draw Tags */
var drawTag = function(x, y){

  noStroke();
  fill(230, 0, 0, 100);
  ellipse(x*zoom, y*zoom, 30, 30);
  fill(230, 0, 0, 255);
  ellipse(x*zoom, y*zoom, 15, 15);
  textSize(18);
  text("Tag", x*zoom+10, y*zoom-10);
}


//Popups
var emp = document.getElementById("edit-map-popup");
var rdp = document.getElementById("remove-device-popup");
var adp = document.getElementById("add-device-popup");
var sp = document.getElementById("settings-popup");

var btn_edit_map = document.getElementById("edit-map");
var btn_remove_device = document.getElementById("remove-device");
var btn_add_device = document.getElementById("add-device");
var btn_settings = document.getElementById("settings");

btn_edit_map.onclick = function() {
  emp.style.display = "block";
}
btn_remove_device.onclick = function() {
  rdp.style.display = "block";
}
btn_add_device.onclick = function() {
  adp.style.display = "block";
}
btn_settings.onclick = function() {
  sp.style.display = "block";
}


function close_popup(){
    rdp.style.display = "none";
    emp.style.display = "none";
    adp.style.display = "none";
    sp.style.display = "none";
}

window.onclick = function(event) {
  if (event.target == emp) {
    emp.style.display = "none";
  }else if(event.target == rdp){
    rdp.style.display = "none";
  }else if(event.target == adp){
    adp.style.display = "none";
  }else if(event.target == sp){
    sp.style.display = "none";
  }
}

/* Anchors Info */
function setAnchorsInfo(){
      ul = document.getElementById('anchors');
      ainfoArray.forEach(function (anchor) {
      let li = document.createElement('li');
      ul.appendChild(li);
      li.classList.add("anchor-info");
      li.innerHTML += anchor[0];
  });
}


/* Tools */
function add_device(){
  addingAnchor = true;
  close_popup();
  aId = document.getElementById("add-device-id").value;
}
