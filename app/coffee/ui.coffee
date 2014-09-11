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

class Inventory

  element: false
  
  constructor: ->
    @element = $('#inventory')
    socket.emit 'userItems'

  destructor: -> $(@element).empty()

  drawInventoryItem: (id, count, name, sprite, offset) ->
    count = "" unless count > 1

    $("<div class=\"tile inventory inventory-#{id}\"><span>#{count}</span></div>").css
      "background-image": "url(/other/#{sprite}.png)"
      "background-position": "-#{offset.x}px -#{offset.y}px"
    .appendTo(@element)

  populate: (items) ->
    for uItem, i in items.inventory
      for sItem in items.itemStore when sItem.id is i
        count = (if uItem.count then uItem.count else "")
        @drawInventoryItem i, count, sItem.name, sItem.sprite, sItem.offset
    false

  addItem: (item) ->
    count = (if item.count then item.count else "")
    inventoryElement = $(".inventory-#{item.id}")
    if inventoryElement.length
      inventoryElement.find('span').html(item.count)
    else
      @drawInventoryItem item.id, count, item.name, item.sprite, item.offset
    $(".inventory-#{item.id}").addClass 'active'
    setTimeout ->
      $(".inventory-#{item.id}").removeClass 'active'
    , 200

  removeItem: (item) ->
    count = (if item.count then item.count else "")
    inventoryElement = $(".inventory-#{item.id}")
    if inventoryElement.length
      span = inventoryElement.find('span')
      if span.html() then span.html(item.count) else inventoryElement.remove()


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
