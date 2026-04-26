// AOS - Animate On Scroll - Minimal
(function() {
  var AOS = function() {
    this.options = { offset: 120, delay: 0, duration: 800, easing: 'ease', once: true };
  };
  AOS.prototype.init = function(options) {
    Object.assign(this.options, options || {});
    this.refresh();
    window.addEventListener('scroll', this.refresh.bind(this));
    window.addEventListener('resize', this.refresh.bind(this));
  };
  AOS.prototype.refresh = function() {
    var elements = document.querySelectorAll('[data-aos]');
    var windowHeight = window.innerHeight;
    elements.forEach(function(el) {
      var position = el.getBoundingClientRect().top;
      if (position < windowHeight - 100) {
        el.classList.add('aos-animate');
      } else if (!this.options.once) {
        el.classList.remove('aos-animate');
      }
    }.bind(this));
  };
  window.AOS = new AOS();
})();
