$(function() {

  // display the loading graphic during ajax requests
  $("#loading").ajaxStart(function(){
     $(this).show();
   }).ajaxStop(function(){
     $(this).hide();
   });

   // make sure we accept javascript for ajax requests
  jQuery.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}});

  if ($('#flash-messages').children().length > 0) {
    $('#flash-messages').show().delay(1000).fadeOut(1500);
  }

});
