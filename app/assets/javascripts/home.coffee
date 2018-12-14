# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.setTimeout (->
  $('.alert').fadeTo(500, 0).slideUp 500, ->
    $(this).remove()
    return
  return
), 2000
