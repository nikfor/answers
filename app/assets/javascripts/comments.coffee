# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


ready = ->
  $('.edit_comment_link').click (e) ->
    comment_id = $(this).data('commentId');
    e.preventDefault();
    $('form#'+comment_id+'.edit_comment').show()
  $('.cancel_form_link').click (e) ->
    e.preventDefault();
    $('form.edit_comment').hide()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)
