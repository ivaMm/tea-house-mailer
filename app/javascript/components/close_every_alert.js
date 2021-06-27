const closeEveryAlert = () => {
  const alert = document.querySelector('body > div > div.alert.alert-info.alert-dismissible.fade.show.m-1');
  if(alert) {
    setTimeout(function(){
      alert.style.display = 'none';
    }, 3000);
  }
}

export { closeEveryAlert };
