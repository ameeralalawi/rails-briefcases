// Javascript to the input form page
var print_text = function(div) {
  console.log("print function")
    // on every key up, we get value in form and put it in preview and replace "@word" with an empty input field.
    var sentence = div.val();
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
    $('#shut').html('');

    syntax.forEach(function(s){
      $('#variables-box').append('<li class="variables-style">'  + s + '</li>');
      //$('#shut').append('<li class="variables-style formula-custom ui-draggable ui-draggable-handle">'  + s + '</li>');
      $('#shut').append('<li><a href="javascript:void(0);" class="formula-custom ui-draggable ui-draggable-handle" data-value="' + s + '">' + s +'</a></li>');
        //<a href="javascript:void(0);" class="formula-custom ui-draggable ui-draggable-handle" data-value="AMEER IS">TEXT AMEER</a>
    });

    document.loadDraggables();
  };



$( document ).ready(function() {

  // function jq(){
  var $this = $("#hello")
  // print_text($this)

  $this.keyup(function() {
    print_text($this)});

  // if we click on "Add variable", it adds an @ sign in our form field (better UX)
  $("#add").click(function(){
      var text = $("#hello")
      text.val(text.val() + '@');
      $("#hello").focus()
    });

  // }



  // $( window ).load(jq() {
  // // Run code
  // });
});


