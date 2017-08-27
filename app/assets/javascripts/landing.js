$("#learn-more a").click(function(e) {
  e.preventDefault();
  var container = $('body'),
  scrollTo = $('#section-2');
  container.animate({
    scrollTop: scrollTo.offset().top - container.offset().top + container.scrollTop()
  });​
});
