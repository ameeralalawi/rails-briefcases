// // Javascript for the output form page

//   var print_output = function(div){

//     // We get text printed in the #output-rext box, replace "@word" with an empty input field and make everythin appear appear in the preview box.
//     var sentence = div.val();
//     var regex = /(?:@[a-zA-Z]+)/g;
//     var sentence_with_input = sentence.replace(regex, '<input type="text" name="amount"/>')

//     $('.text-output').html(sentence_with_input);
//   };




// $( document ).ready(function() {

//   //The default output text is printed on the preview box.
//   var $that = $("#output-text")
//   print_output($that);
//   shouldBeChecked();




//   // On keyup, we call the print_output() function
//   $that.keyup(function() {
//     print_output($that)
//     shouldBeChecked();
//   });





//   // When I check/uncheck checkbox, it displays its value in the output box field editor.
//   function setValue(input_id) {
//     var $that = $("#output-text")
//     var text = $('#output-text').val();
//     var item = $('#' + input_id);

//         if (item.is(":checked")) {
//           text = text + item.val();
//           $("#output-text").focus()
//         } else if (item.is(':checkbox:not(:checked)')) {
//           text = text.replace(item.val(), "");
//           $("#output-text").focus()

//         };

//         $('#output-text').val(text)
//         print_output($that);
//   };


//   // When a variable is in the text, the box should be checked.
//   function shouldBeChecked(){
//     var field = $('#output-text').val();

//     if (field.indexOf("BAEndofPeriodVal") >= 0){
//       $("#BAEndofPeriodVal").prop('checked', true)
//     } else {
//       $("#BAEndofPeriodVal").prop('checked', false)
//     };

//      if (field.indexOf("ABEndofPeriodVal") >= 0){
//       $("#ABEndofPeriodVal").prop('checked', true)
//     }else {
//       $("#ABEndofPeriodVal").prop('checked', false)
//     };

//      if (field.indexOf("ReturnOnInvestedCapital") >= 0){
//       $("#ReturnOnInvestedCapital").prop('checked', true)
//     } else {
//       $("#ReturnOnInvestedCapital").prop('checked', false)
//     };

//      if (field.indexOf("InternalRateOfReturn") >= 0){
//       $("#InternalRateOfReturn").prop('checked', true)
//     } else {
//       $("#InternalRateOfReturn").prop('checked', false)
//     };

//      if (field.indexOf("FirstBreakeveInMonths") >= 0){
//       $("#FirstBreakeveInMonths").prop('checked', true)
//     } else {
//       $("#FirstBreakeveInMonths").prop('checked', false)
//     };

//      if (field.indexOf("SecondBreakeveInMonths") >= 0){
//       $("#SecondBreakeveInMonths").prop('checked', true)
//     }else {
//       $("#SecondBreakeveInMonths").prop('checked', false)
//     };
//   };






//     $(".output-check").change(function () {
//       setValue(this.id);
//     });



// });

