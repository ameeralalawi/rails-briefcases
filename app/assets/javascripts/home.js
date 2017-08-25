$(document).ready(function(e) {

    var nowTemp = new Date();
    var now = nowTemp.getDate()+'-'+ (nowTemp.getMonth()+1)+'-'+ nowTemp.getFullYear();

    $('.chkin').datepicker({
        format : 'dd/mm/yyyy',
        orientation: "bottom",
        autoclose: true,
        todayHighlight: true,
        startDate: now
        }).on('changeDate', function(ev) {
            $('.chkout').trigger('click');
            checko.data('datepicker').setStartDate(ev.date);
        });

    checko = $('.chkout').datepicker({
        format : 'dd/mm/yyyy',
        startDate:now,
        orientation: "bottom",
        autoclose: true,
    });

    $('#glyph-chkin').click(function(event){
      event.preventDefault();
      $('.chkin').data("datepicker").show();
    });

    $('#glyph-chkout').click(function(event){
      event.preventDefault();
      $('.chkout').data("datepicker").show();
    });
});
