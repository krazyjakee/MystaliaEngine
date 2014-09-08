class Input

  hero: false
  direction: false
  freeze: false

  constructor: (character) ->

    @hero = character
    that = @
    afterMove = (doDirection) -> 
      if that.direction is that.hero.direction
        that.hero.move that.hero.direction, afterMove
      else
        that.hero.element.removeClass "sprite-animate-#{doDirection}"

    directionKeyUp = -> that.direction = false

    KeyboardJS.clear("w")
    KeyboardJS.on "w", ->
      unless that.freeze
        that.hero.move 3, afterMove if that.direction != 3
        that.direction = 3
    , directionKeyUp
    KeyboardJS.clear("d")
    KeyboardJS.on "d", ->
      unless that.freeze
        that.hero.move 2, afterMove if that.direction != 2
        that.direction = 2
    , directionKeyUp
    KeyboardJS.clear("s")
    KeyboardJS.on "s", ->
      unless that.freeze
        that.hero.move 0, afterMove if that.direction != 0
        that.direction = 0
    , directionKeyUp
    KeyboardJS.clear("a")
    KeyboardJS.on "a", ->
      unless that.freeze
        that.hero.move 1, afterMove if that.direction != 1
        that.direction = 1
    , directionKeyUp