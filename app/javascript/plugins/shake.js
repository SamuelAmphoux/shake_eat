function handleMotionEvent(event) {

  var x = event.accelerationIncludingGravity.x;
  var y = event.accelerationIncludingGravity.y;
  var z = event.accelerationIncludingGravity.z;

  // Faire quelque chose de génial.
}

window.addEventListener("devicemotion", handleMotionEvent, true);
