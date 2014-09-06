$(function() {
    var nav = $('nav');
    var bodyContainer = $('.container');
    var initialMargin = parseInt( bodyContainer.css('margin-top') );
    var marginFix = initialMargin + nav.height();

    $(window).scroll(function() {
      var navHeight = $( window ).height() - nav.offset().top + nav.height() + nav.outerHeight();
      if ($(window).scrollTop() > navHeight) {
        nav.addClass('fixed');
        bodyContainer.css('margin-top', marginFix + 'px');
      } else {
        nav.removeClass('fixed');
        bodyContainer.css('margin-top', initialMargin + 'px');
      }
    });
});
