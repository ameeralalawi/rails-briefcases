function variables_refresh() {
  console.log("variable refresh run outer")
  var expVars = window.expertVariables;
  Object.keys(expVars).forEach(function(index) {
    $('#shut').append('<li><a href="javascript:void(0);" class="formula-custom ui-draggable ui-draggable-handle" data-value="' + JSON.stringify(expVars[index].expression) + '">' + expVars[index].name +'</a></li>');
    console.log("variable refresh run inner")
  });
}



