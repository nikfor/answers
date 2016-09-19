# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


ready = ->
  $('.delete_file_link').click (e) ->
    e.preventDefault();
    $(this).parent().hide();

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)
