class Character

  id: false
  position: false
  sprite: false
  controllable: false
  element: false

  moving: false
  direction: false

  constructor: (id, sprite, startPosition, controllable = "") ->
    console.log "Creating character #{id}."
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
    @element.addClass "sprite-animate-#{doDirection}"
    y = direction * 32
    @element.css
      "background-position": "-32px -#{y}px"

  move: (direction, callback = false) ->
    if @moving is false
      @moving = true
      @direction = direction
      that = @
      doMove = (css, doDirection) ->
        that.animate direction, doDirection
        that.element.animate css, 400, 'linear', ->
          if callback
            that.moving = false
            callback(doDirection)
          else
            that.moving = false
            that.element.removeClass "sprite-animate-#{doDirection}"
      switch direction
        when 0
          doMove { top: "+=32px" }, 'down'
        when 1
          doMove { left: "-=32px" }, 'left'
        when 2
          doMove { left: "+=32px" }, 'right'
        when 3
          doMove { top: "-=32px" }, 'up'