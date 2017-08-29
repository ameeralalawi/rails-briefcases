
$(document).ready(function() {

  $('#fullpage').fullpage({

    //Navigation
    menu: true,
    lockAnchors: false,
    anchors:['firstPage', 'secondPage', 'thirdPage', 'fourthPage', 'fifthPage', 'sixthPage'],
    navigation: false,
    navigationPosition: 'right',
    navigationTooltips: ['firstSlide', 'secondSlide','thirdSlide', 'fourthSlide', 'fifthSlide', 'sixthSlide'],
    showActiveTooltip: false,
    slidesNavigation: false,
    slidesNavPosition: 'bottom',

    //Scrolling
    css3: true,
    scrollingSpeed: 650,
    autoScrolling: true,
    fitToSection: true,
    fitToSectionDelay: 1000,
    scrollBar: false,
    easing: 'easeInOutCubic',
    easingcss3: 'ease',
    loopBottom: false,
    loopTop: false,
    loopHorizontal: true,
    continuousVertical: false,
    continuousHorizontal: false,
    scrollHorizontally: false,
    interlockedSlides: false,
    dragAndMove: false,
    offsetSections: false,
    resetSliders: false,
    fadingEffect: false,
    normalScrollElements: '#lines-scroll',
    scrollOverflow: false,
    scrollOverflowReset: false,
    scrollOverflowOptions: null,
    touchSensitivity: 15,
    normalScrollElementTouchThreshold: 5,
    bigSectionsDestination: null,

    //Accessibility
    keyboardScrolling: true,
    animateAnchor: true,
    recordHistory: true,

    //Design
    controlArrows: true,
    verticalCentered: true,
    sectionsColor : ['#ccc', '#fff'],
    paddingTop: '0px',
    paddingBottom: '0px',
    fixedElements: '#header, .footer',
    responsiveWidth: 0,
    responsiveHeight: 0,
    responsiveSlides: false,
    parallax: false,
    parallaxOptions: {type: 'reveal', percentage: 62, property: 'translate'},

    //Custom selectors
    sectionSelector: '.section',
    slideSelector: '.slide',

    lazyLoading: true,

    //events
    onLeave: function(index, nextIndex, direction){
      if(index == 1){
        $('#global-save-1').trigger('click');
      }

      else if(index == 2){
        $('#global-save-2').trigger('click');
      }

      else if(index == 3){
        // $('#global-save-3').trigger('click');
      }

      else if(index == 4){
        // $('#global-save-4').trigger('click');
      }

      else if(index == 5){
        // $('#global-save-5').trigger('click');
      }

      else if(index == 6){
        // $('#global-save-5').trigger('click');
      }
    },
    afterLoad: function(anchorLink, index){
      if(index == 1){
        console.log("Arriving input page!");
      }

      else if(index == 2){
        console.log("Arriving output page!");
      }

      else if(index == 3){
        console.log("Arriving variable page!");
      }

      else if(index == 4){
        console.log("Arriving testdata page!");
      }

      else if(index == 5){
        console.log("Arriving lines page!");
      }

      else if(index == 6){
        console.log("Arriving publish/preview page!");
      }
    },
    afterRender: function(){},
    afterResize: function(){},
    afterResponsive: function(isResponsive){},
    afterSlideLoad: function(anchorLink, index, slideAnchor, slideIndex){},
    onSlideLeave: function(anchorLink, index, slideIndex, direction, nextSlideIndex){}
  });
});

