function variables_refresh() {
  var expVars = window.expertVariables;
  Object.keys(expVars).forEach(function(index) {
    $('#shut').append('<li><a href="javascript:void(0);" class="formula-custom ui-draggable ui-draggable-handle" data-value="' + expVars[index].expression + '">' + expVars[index].name +'</a></li>');
  });

}
