class Input

  hero: false
  direction: false

  constructor: (character) ->

    @hero = character
    that = @
    afterMove = (doDirection) -> 
      if that.direction is that.hero.direction
        that.hero.move that.hero.direction, afterMove
      else
        that.hero.element.removeClass "sprite-animate-#{doDirection}"

    keyUp = ->
      # classes = ("sprite-animate-"+d for d in ["up", "down", "left", "right"])
      # that.hero.element.removeClass(classes.join(", "))
      that.direction = false

    KeyboardJS.on "w", ->
      that.hero.move 3, afterMove if that.direction != 3
      that.direction = 3
    , keyUp
    KeyboardJS.on "d", ->
      that.hero.move 2, afterMove if that.direction != 2
      that.direction = 2
    , keyUp
    KeyboardJS.on "s", ->
      that.hero.move 0, afterMove if that.direction != 0
      that.direction = 0
    , keyUp
    KeyboardJS.on "a", ->
      that.hero.move 1, afterMove if that.direction != 1
      that.direction = 1
    , keyUp