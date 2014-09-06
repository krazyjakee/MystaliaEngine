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