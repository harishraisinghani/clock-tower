$(function() {
  $('.chosen-select').chosen();
  $('.pick-a-date').pickadate({
    format: 'mmmm d, yyyy'
  });
  $('[data-toggle="tooltip"]').tooltip();
});
