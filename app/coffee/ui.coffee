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

    $("<div class=\"tile inventory inventory-#{id}\" title=\"#{name}\"><span>#{count}</span></div>").css
      "background-image": "url(/other/#{sprite}.png)"
      "background-position": "-#{offset.x}px -#{offset.y}px"
    .appendTo(@element)

  populate: (items) ->
    @element.empty()
    for uItem, i in items.inventory
      for sItem in items.itemStore when sItem.id is i
        count = (if uItem.count then uItem.count else "")
        @drawInventoryItem i, count, sItem.name, sItem.sprite, sItem.offset
    false
    $('.inventory[title]').tooltip()

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

class Shop

  constructor: (shop, items) ->
    $.get "/shopModal", (res) ->
      modal = $(res)
      modal.attr('id', "shop-#{shop.id}")
      modal.find('.modal-title').html shop.name
      modal.find('.modal-body p').html shop.introduction
      for trade, index in shop.trades
        tradeElem = modal.find('.row').clone()
        modal.find('.modal-body .row').remove()
        _renderTrades = (tradeSet, classIdent) ->
          for tradeItem in tradeSet
            itemElem = tradeElem.find(".#{classIdent} .tile").clone()
            tradeElem.find(".#{classIdent}").html('')
            for item in items when item.id is tradeItem.id
              itemElem.css
                "background-image": "url(/other/#{item.sprite}.png)"
                "background-position": "-#{item.offset.x}px -#{item.offset.y}px"
              itemElem.attr 'title', item.name
              itemElem.find('span').html(tradeItem.count) if tradeItem.count > 1
            tradeElem.find(".#{classIdent}").append itemElem

        _renderTrades trade.itemIn, 'first'
        _renderTrades trade.itemOut, 'second'
        tradeElem.find('.btn').attr
          'data-shopid': shop.id
          'data-tradeindex': index
        modal.find('.modal-body').append tradeElem
        
      $(document.body).append modal
      playerInput.freeze = true
      $("#shop-#{shop.id}").modal('show')
      .on 'hidden.bs.modal', ->
        $(@).remove()
        playerInput.freeze = false
      .find('.btn').click ->
        socket.emit 'shopTrade',
          shopId: $(@).data('shopid')
          tradeIndex: $(@).data('tradeindex')
        $("#shop-#{shop.id}").modal('hide')
      $('.inventory[title]').tooltip()
          

$(window).load ->
  $('#message-btn').click -> socket.emit 'chat', $('#chat-input').val()
  $('#chat-input').focus -> 
    playerInput.freeze = true
  .blur ->
    playerInput.freeze = false
  .keypress (e) ->
    if e.which is 13
      $('#message-btn').click()
      $('#chat-input').val('')
      $('#chat-well').scrollTop($('#chat-well br').length * 20)
