class Character

  id: false # the unique id of the character
  position: false # the location of the sprite
  sprite: false # the name of the sprite
  controllable: false # is this the hero sprite?
  element: false # the sprite element in the dom

  moving: false # is the sprite currently in motion?
  direction: false # which way is it facing?

  constructor: (id, sprite, startPosition, controllable = "") ->
    controllable = "hero" if controllable

    @position = startPosition
    @sprite = sprite
    @controllable = controllable
    @id = id

    elem = $("<div id='#{controllable}' class='character sprite-#{sprite}' data-id='#{id}'></div>").css
      "background-image": "url(/sprite/#{sprite}.png)"
      "left": startPosition.x
      "top": startPosition.y
    $('.layer-Player').append elem

    @element = elem

  animate: (direction, doDirection) ->
    y = direction * 32
    @element.addClass "sprite-animate-#{doDirection}"
    @element.css
      "background-position": "-32px -#{y}px"

  attributeProperties: (attribute, tileId) ->
    for attribute in map.attributes[attribute] when attribute.id is tileId
      return attribute.properties

  checkNextTile: (newPosition) ->
    if newPosition.x < 0
      return map.changeMap "West"
    if newPosition.x >= map.json.width * 32
      return map.changeMap "East"
    if newPosition.y < 0
      return map.changeMap "North"
    if newPosition.y >= map.json.height * 32
      return map.changeMap "South"

    id = map.locationToId(newPosition)
    attribute = map.getTileAttribute(id)
    switch attribute
      when "block" then return false
      when "door"
        properties = @attributeProperties "door", id
        socket.emit 'move', newPosition
        map.warpMap properties.Map
        return true
      when "sign"
        properties = @attributeProperties "sign", id
        window.activeSign = new Sign(properties.Message, properties.Material).show() unless window.activeSign
        return false
    true

  move: (direction, callback = false) ->
    if @moving is false
      @moving = true
      @direction = direction
      that = @
      doMove = (css, doDirection, newPosition) ->
        # begin the animation class and style
        that.animate direction, doDirection
        # if the destination tile is not blocked
        if that.checkNextTile newPosition
          activeSign.hide() if activeSign
          socket.emit 'move', newPosition
          that.position = newPosition
          that.element.clearQueue()
          .animate css, 300, 'linear', ->
            that.moving = false
            # if there is a callback let it handle the animation class
            if callback
              callback(doDirection)
            else
              that.element.removeClass "sprite-animate-#{doDirection}"
        else
          that.element.removeClass "sprite-animate-#{doDirection}"
          that.moving = false

      # depending on the direction, move the sprite, add the animation class and update the new position.
      switch direction
        when 0
          doMove { top: "+=32px" }, 'down', { x: that.position.x, y: that.position.y + 32 }
        when 1
          doMove { left: "-=32px" }, 'left', { x: that.position.x - 32, y: that.position.y }
        when 2
          doMove { left: "+=32px" }, 'right', { x: that.position.x + 32, y: that.position.y }
        when 3
          doMove { top: "-=32px" }, 'up', { x: that.position.x, y: that.position.y - 32 }