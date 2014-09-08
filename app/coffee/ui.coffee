window.activeSign = false
class Sign
  
  element: false
  constructor: (message, material) ->
    @element = $("<div class='sign #{material}'>#{message}</div>").appendTo('#game')

  show: ->
    that = @
    setTimeout ->
      that.element.addClass 'active'
    , 10
    @

  hide: ->
    that = @
    @element.removeClass 'active'
    setTimeout ->
      that.element.remove()
    , 1000
    window.activeSign = false

$(window).load ->
  $('#message-btn').click -> socket.emit 'chat', $('#chat-input').val()
  $('#chat-input').focus -> 
    playerInput.freeze = true
    console.log playerInput
  .blur ->
    playerInput.freeze = false
  .keypress (e) ->
    if e.which is 13
      $('#message-btn').click()
      $('#chat-input').val('')
      $('#chat-well').scrollTop($('#chat-well br').length * 20)
