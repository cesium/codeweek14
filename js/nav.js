$(function() {
    var nav = $('nav');
    var bodyContainer = $('.container');
    var initialMargin = parseInt( bodyContainer.css('margin-top') );
    var marginFix = initialMargin + nav.height();
    var navHeight = nav.height() + nav.outerHeight();

    $(window).scroll(function() {
      var navPosition = $( window ).height() - nav.offset().top + navHeight;
      if ($(window).scrollTop() > navPosition) {
        nav.addClass('fixed');
        bodyContainer.css('margin-top', marginFix + 'px');
      } else {
        nav.removeClass('fixed');
        bodyContainer.css('margin-top', initialMargin + 'px');
        $('.active-link').removeClass('active-link');
      }

    });


    nav.find('a').on('click', function() {
      var top = $('html, body');
      var self = $(this);
      top.animate({
        'scrollTop': $('#' + self.data('target')).offset().top - navHeight
      }, 1000).promise().done(function() {
        $('.active-link').removeClass('active-link');
        self.addClass('active-link');
      });
    });
});
