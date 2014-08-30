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