// ===== Academics Template - Main JavaScript =====

(function($) {
  "use strict";

  // Loader
  $(window).on('load', function() {
    setTimeout(function() {
      $('#loader').removeClass('show');
      $('#loader').addClass('fullscreen');
    }, 500);
  });

  // AOS Init
  if (typeof AOS !== 'undefined') {
    AOS.init({
      duration: 800,
      easing: 'slide',
      once: true
    });
  }

  // Sticky Header
  var siteSticky = function() {
    $(".js-sticky-header").sticky({topSpacing:0});
  };
  siteSticky();

  // Site Menu Clone for Mobile
  var siteMenuClone = function() {
    $('.js-clone-nav').each(function() {
      var $this = $(this);
      $this.clone().attr('class', 'site-nav-wrap').appendTo('.site-mobile-menu-body');
    });
    setTimeout(function() {
      var counter = 0;
      $('.site-mobile-menu .has-children').each(function(){
        var $this = $(this);
        $this.prepend('<span class="arrow-collapse collapsed">');
        $this.find('.arrow-collapse').attr({
          'data-toggle' : 'collapse',
          'data-target' : '#collapseItem' + counter,
        });
        $this.find('> ul').attr({
          'class' : 'collapse',
          'id' : 'collapseItem' + counter,
        });
        counter++;
      });
    }, 1000);
  };
  siteMenuClone();

  // Mobile Menu Toggle
  var sitePlusMinus = function() {
    $('.js-menu-toggle').on('click', function(e) {
      e.preventDefault();
      if ($('body').hasClass('offcanvas-menu')) {
        $('body').removeClass('offcanvas-menu');
        $('.js-menu-toggle').removeClass('active');
      } else {
        $('body').addClass('offcanvas-menu');
        $('.js-menu-toggle').addClass('active');
      }
    });
    $(document).mouseup(function(e) {
      var container = $(".site-mobile-menu");
      if (!container.is(e.target) && container.has(e.target).length === 0) {
        if ($('body').hasClass('offcanvas-menu')) {
          $('body').removeClass('offcanvas-menu');
        }
      }
    });
  };
  sitePlusMinus();

  // Owl Carousel - Hero Slider
  var heroCarousel = function() {
    if ($.fn.owlCarousel) {
      $('.hero-slide').owlCarousel({
        items: 1,
        loop: true,
        autoplay: true,
        autoplayTimeout: 5000,
        nav: true,
        dots: true,
        navText: ['<span class="icon-chevron-left">', '<span class="icon-chevron-right">'],
        smartSpeed: 1000
      });
    }
  };
  heroCarousel();

  // Owl Carousel - Courses
  var courseCarousel = function() {
    if ($.fn.owlCarousel) {
      $('.owl-slide-3').owlCarousel({
        center: false,
        items: 1,
        loop: true,
        autoplay: true,
        autoplayTimeout: 3000,
        stagePadding: 10,
        nav: true,
        navText: ['<span class="icon-chevron-left">', '<span class="icon-chevron-right">'],
        responsive: {
          600: { items: 3 },
          1000: { items: 3 }
        }
      });
    }
  };
  courseCarousel();

  // Owl Carousel - Testimonials
  var testimonialCarousel = function() {
    if ($.fn.owlCarousel) {
      $('.owl-slide').owlCarousel({
        center: false,
        items: 1,
        loop: true,
        autoplay: true,
        autoplayTimeout: 4000,
        stagePadding: 0,
        nav: true,
        navText: ['<span class="icon-chevron-left">', '<span class="icon-chevron-right">'],
        responsive: {
          600: { items: 2 },
          1000: { items: 3 }
        }
      });
    }
  };
  testimonialCarousel();

  // Stellar Parallax
  var siteStellar = function() {
    if ($.fn.stellar) {
      $(window).stellar({
        responsive: true,
        parallaxBackgrounds: true,
        parallaxElements: true,
        horizontalScrolling: false,
        hideDistantElements: false,
        horizontalOffset: 0,
        verticalOffset: 0
      });
    }
  };
  siteStellar();

  // Datepicker
  if ($.fn.datepicker) {
    $('.js-datepicker').datepicker();
  }

  // Fancybox
  if ($.fn.fancybox) {
    $('[data-fancybox]').fancybox({
      youtube: { controls: 0, showinfo: 0 },
      vimeo: { byline: 0, portrait: 0 }
    });
  }

  // Smooth Scroll
  var smoothScroll = function() {
    $('a[href^="#"]').on('click', function(e) {
      var target = $(this.getAttribute('href'));
      if (target.length) {
        e.preventDefault();
        $('html, body').stop().animate({
          scrollTop: target.offset().top - 50
        }, 1000);
      }
    });
  };
  smoothScroll();

})(jQuery);
