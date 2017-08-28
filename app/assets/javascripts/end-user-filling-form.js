 var emptyField = function() {
  var input = $('#filling').val();
  var regex = /(?:@[a-zA-Z]+)/g;
  var input_empty_fields = input.replace(regex, '<input type="text" name="amount"/>');
  //console.log(input_empty_fields);

  $('.input-field').html(input_empty_fields);

};





$( document ).ready(function(){
//console.log('heyyy')
$('#filling').hide()
 emptyField()


$('#turn-card').on("click", function(){

  $("#preview").flip();
});








});
