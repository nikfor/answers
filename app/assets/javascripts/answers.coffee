# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit_answer_link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
vote_ready = ->
  $('.vote_link').bind 'ajax:success', (e, data, status, xhr) ->
    voteable = $.parseJSON(xhr.responseText);
    $('#total-votes-' + voteable.id).html(voteable.total)
  $('.vote_block').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText);
    $('#errors-voteable-' + errors.id).html(errors.error)
  $('.cancel_l').click (e) ->
    $(this).toggle(false);
  $('.nay').click (e) ->
    $('#' + this.id + '.cancel_l').toggle(true);
  $('.yea').click (e) ->
    $('#' + this.id + '.cancel_l').toggle(true);
  $('.comment_answer_link').click (e) ->
    answer_id = $(this).data('answerId')
    e.preventDefault();
    $('.answers-block .answer_' + answer_id + ' .new_comment').show()


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('turbolinks:load', ready)

$(document).on('turbolinks:load', vote_ready)
