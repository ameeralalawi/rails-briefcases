
$(document).ready(function() {


      $('li > ul > li > a').click(function(){
        console.log("test");
        //section page scrolls if submenu clicked
        $.fn.fullpage.moveTo( $(this).attr('href') );

        //Toggle class "active" of submenu
        $(".active").removeClass("active");
        $(this).closest('li').addClass("active");
        var theClass = $(this).attr("class");
        $('.'+theClass).parent('li').addClass('top-active');
      });

      //collapse submenu if click to other main-menu tab
      $('ul li').filter(".pointer").on('click', function (event) {
        console.log("beatl");
        // event.preventDefault();
        if ($('[aria-expanded=true]').length > 0) {
          $('#pageSubmenu').collapse('hide');
          $('#pageSubmenu-target').attr('data-toggle', 'collapse')
        }
      });

      //Toggle class "active" of main-menu
      $('li').on('click', function (event) {
        console.log("yey-");
        $("li").removeClass("top-active")
        // $("li").parent('li').eq(2).removeClass("top-active")
        $(this).toggleClass('top-active');
      });
});






  //by template
  // $(document).ready(function () {
  //        $("#sidebar").niceScroll({
  //            cursorcolor: '#53619d',
  //            cursorwidth: 4,
  //            cursorborder: 'none'
  //        });


  //        $('#sidebarCollapse').on('click', function () {
  //            // $('#sidebar, #content').toggleClass('active');
  //            $('#sidebar').toggleClass('top-active');
  //            $('.collapse.in').toggleClass('in');
  //            $('a[aria-expanded=true]').attr('aria-expanded', 'false');
  //        });
  //    });

