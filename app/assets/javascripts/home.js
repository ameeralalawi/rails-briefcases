$(document).ready(function(e) {
    var clipboard = new Clipboard('.copy-btn');
    var nowTemp = new Date();
    var now = nowTemp.getDate()+'-'+ (nowTemp.getMonth()+1)+'-'+ nowTemp.getFullYear();

    $('.chkin').datepicker({
        format : 'dd/mm/yyyy',
        orientation: "auto",
        autoclose: true,
        todayHighlight: true,
        startDate: now
        }).on('changeDate', function(ev) {
            $(this).parents(':eq(3)').find('.chkout').trigger('click');
            $(this).parents(':eq(3)').find('.chkout').val("");
            $(this).parents(':eq(3)').find('.chkout').data('datepicker').setStartDate(ev.date);
        });

    $('.chkout').datepicker({
        format : 'dd/mm/yyyy',
        startDate:now,
        orientation: "auto",
        autoclose: true,
    });

    $('.glyph-chkin').click(function(event){
      event.preventDefault();
      $(this).parents(':eq(3)').find('.chkout').data("datepicker").show();
    });

    $('.glyph-chkout').click(function(event){
      event.preventDefault();
      $(this).parents(':eq(3)').find('.chkout').data("datepicker").show();
    });
});
