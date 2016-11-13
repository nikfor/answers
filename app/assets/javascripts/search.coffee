# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.search_form_link').click (e) ->
    e.preventDefault();
    $('.search_form').show()
  $('.cancel_search_link').click (e) ->
    e.preventDefault();
    $('.search_form').hide()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('turbolinks:load', ready)
