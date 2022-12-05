if (typeof DeviceMotionEvent.requestPermission === 'function') {
  DeviceMotionEvent.requestPermission()
    .then(permissionState => {
      if (permissionState === 'granted') {
        window.addEventListener('devicemotion', (event) => {
          console.log(event.accelerationIncludingGravity)
        });
      }
    })
    .catch(console.error);
} else {
  // handle regular non iOS 13+ devices
}
