// Admin Dashboard - Main JS
(function($) {
  "use strict";
  $(document).ready(function() {
    // Confirm delete actions
    $('a[href*="delete"]').on('click', function(e) {
      if (!confirm('Are you sure you want to delete this item?')) {
        e.preventDefault();
      }
    });
  });
})(jQuery);
