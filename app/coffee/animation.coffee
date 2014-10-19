$(window).load ->
  # sprite animation
  $.keyframe.define [
      name: 'sprite-animate-down'
      '0%': { 'background-position': '0 0' }
      '33%': { 'background-position': '32px 0' }
      '66%': { 'background-position': '64px 0' }
    ,
      name: 'sprite-animate-up'
      '0%': { 'background-position': '0 32px' }
      '33%': { 'background-position': '32px 32px' }
      '66%': { 'background-position': '64px 32px' }
    ,
      name: 'sprite-animate-right'
      '0%': { 'background-position': '0 64px' }
      '33%': { 'background-position': '32px 64px' }
      '66%': { 'background-position': '64px 64px' }
    ,
      name: 'sprite-animate-left'
      '0%': { 'background-position': '0 96px' }
      '33%': { 'background-position': '32px 96px' }
      '66%': { 'background-position': '64px 96px' }
  ]

Effects =

  activeEffect: false

  none: ->
    Effects.activeEffect = false
    $('#game').attr 'data-effect', 'none'
    $('svg').css 'opacity', 0

  dark: ->
    Effects.activeEffect = "dark"
    $('#game').attr 'data-effect', 'dark'
    fl = new Flashlight
      target: $('#game')
      output: $('.layer-Player')
      width: 400
      height: 280
      gradient: ["#888", "#aaa", "white"]
      lights: [{x: 260, y: 180}]
    $("[result=\"light0\"]").css
      'left': player.position.x - 100
      'top': player.position.y - 100
    .attr
      dx: player.position.x - 100
      dy: player.position.y - 100
    $('svg').css 'opacity', 1

  lighter: ->
    Effects.activeEffect = "lighter"
    Effects.dark() unless $('svg').length
    $('#game').attr 'data-effect', 'lighter'
    $('svg').css 'opacity', 0.5
