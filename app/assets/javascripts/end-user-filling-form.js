 var emptyField = function() {
  var input = $('#filling').val();
  var regex = /(?:@[a-zA-Z]+)/g;
  var input_empty_fields = input.replace(regex, '<input type="text" name="amount"/>');
  //console.log(input_empty_fields);

  $('.input-field').html(input_empty_fields);

};






