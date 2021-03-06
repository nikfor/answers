# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit_question_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form.question_edit_form').show()
  $('.new_question_link').click (e) ->
    e.preventDefault();
    $('form.question_new_form').show()
  $('.cancel_form_link').click (e) ->
    e.preventDefault();
    $('form.question_new_form').hide()
  $('.comment_question_link').click (e) ->
    e.preventDefault();
    $('.question-block .new_comment').show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)
