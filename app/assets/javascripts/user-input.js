// Javascript to the input form page

$( document ).ready(function() {

  $("#hello").keyup(function() {
    // on every key up, we get value in form and put it in preview and replace "@word" with an empty input field.
    var sentence = $(this).val();
    var regex = /(?:@[a-zA-Z]+)/g;
    var sentence_with_input = sentence.replace(regex, '<input type="text" name="amount"/>')
    $('.text-input').html(sentence_with_input);



    // we check the string that start with @ and remove special characters after that string
    var variables = []
    // var regex = /(?:@[a-zA-Z]+)/g;
    var moto;

    do {
      moto = regex.exec(sentence);
      if (moto) {
        variables.push(moto[0]);
      }
    } while (moto);

    // we transform the array variables into an oject call obj
    function toObject(arr) {
      var rv = {};
      for (var i = 0; i < arr.length; ++i)
        rv[arr[i]] = arr[i];
      return rv;
    }
    obj = toObject(variables)

    // we store all the values of the keys of that object into the array syntax
    var syntax = Object.values(obj)

    // we append every of those value to our variables box
    $('#variables-box').html('');

    syntax.forEach(function(s){
      $('#variables-box').append('<li class="variables-style">'  + s + '</li>');
      // $(".text-input").append('<input type="text" name="amount"/>');
    });


  });

  // if we click on "Add variable", it adds an @ sign in our form field (better UX)
  $("#add").click(function(){
      var text = $("#hello")
      text.val(text.val() + '@');
      $("#hello").focus()
    });


});

