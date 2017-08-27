// Javascript for the output form page

  var print_output = function(div){

    // We get text printed in the #output-rext box, replace "@word" with an empty input field and make everythin appear appear in the preview box.
    var sentence = div.val();
    var regex = /(?:@[a-zA-Z]+)/g;
    var sentence_with_input = sentence.replace(regex, '<input type="text" name="amount"/>')

    $('.text-output').html(sentence_with_input);

      // we check the string that start with @ and remove special characters after that string
      // var variables = []
      // var moto;

      // do {
      //   moto = regex.exec(sentence);
      //   if (moto) {
      //     variables.push(moto[0]);
      //   }
      // } while (moto);

      // we transform the array variables into an oject call obj
      // function toObject(arr) {
      //   var rv = {};
      //   for (var i = 0; i < arr.length; ++i)
      //     rv[arr[i]] = arr[i];
      //   return rv;
      // }
      // obj = toObject(variables)

      // we store all the values of the keys of that object into the array syntax
     // var syntax = Object.values(obj)


  };

  //Make the value of the checkbox appear in the output text field when checked.
   // $(".output-check").change(function() {
   //   var ischecked = $(this).is(':checked');
   //   var unchecked = $(this).is(':checkbox:not(:checked)')
   //   if (unchecked){
   //    console.log('unchecked')
    //$('#output-text').css('background-color', 'red')
    //$("#output-text").find($(this).val()).remove();
//     $('output-text').each(function(){
//     $(this).html($(this).html().split("By:").join(""));
// });
//   }

//      else if (ischecked){
//         $('#output-text').val( $('#output-text').val() + $(this).val() + ' ' );
//         $("#output-text").focus()
//      }
//  });

$( document ).ready(function() {

  //The default output text is printed on the preview box.
  var $that = $("#output-text")
  print_output($that)

  // On keyup, we call the print_output() function
  $that.keyup(function() {
    print_output($that)
  });

  // When I check/uncheck checkbox, it displays its value in the output box field editor.
  function setValue() {
    var items = $(".output-check");
    var result = [];
    for (var i = 0; i < items.length; i++) {
        var item = $(items[i]);
        if (item.is(":checked")) {
          result.push(item.val());
        }
    }
    var text = result.join();
    $("#output-text").val(text);
    //$('#output-text').val( $('#output-text').val() + text + ' ' );
    $("#output-text").focus()
  };

    $(".output-check").change(function () {
    setValue();
  });


});

