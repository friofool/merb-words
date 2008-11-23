$(document).keyup(function(event){
  if (event.keyCode == 119) {
    windowOpen('/password/read');
  }
  else if (event.keyCode == 118) {
    window.location = '/password/exit';
  }
});