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

    for c in ["w","a","s","d","left","up","down","right","space"] 
      KeyboardJS.clear c

    KeyboardJS.on "w, up", (e) ->
      e.preventDefault()
      unless that.freeze
        that.hero.move 3, afterMove if that.direction != 3
        that.direction = 3
    , directionKeyUp
    KeyboardJS.on "d, right", (e) ->
      e.preventDefault()
      unless that.freeze
        that.hero.move 2, afterMove if that.direction != 2
        that.direction = 2
    , directionKeyUp
    KeyboardJS.on "s, down", (e) ->
      e.preventDefault()
      unless that.freeze
        that.hero.move 0, afterMove if that.direction != 0
        that.direction = 0
    , directionKeyUp
    KeyboardJS.on "a, left", (e) ->
      e.preventDefault()
      unless that.freeze
        that.hero.move 1, afterMove if that.direction != 1
        that.direction = 1
    , directionKeyUp
    KeyboardJS.on "space", (e) ->
      e.preventDefault()
      that.hero.action()