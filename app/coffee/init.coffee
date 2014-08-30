$(window).load ->
  map = new tmx2html()
  map.load 'test', '/map/test', (json, name) ->
    maphtml = map.render 'test'
    $('#game').html maphtml