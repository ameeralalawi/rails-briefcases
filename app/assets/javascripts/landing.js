$("#learn-more a").click(function(e) {
  e.preventDefault();
  var container = $('body');
  var scrollTo = $('#section-2');
  container.animate({
    scrollTop: scrollTo.offset().top - container.offset().top + container.scrollTop()
  })
});

$("#go-down a").click(function(e) {

  e.preventDefault();
  var container = $('body');
  var scrollTo = $('#section-3');
  container.animate({
    scrollTop: scrollTo.offset().top - container.offset().top + container.scrollTop()
  })
});
