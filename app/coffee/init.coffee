$(window).load ->
  map = new tmx2html()
  map.load 'test', '/map/test', (json, name) ->
    maphtml = map.render 'test'
    $('#game').html maphtml

    ragnar = new Character('ragnar', 'ragnar', {x: 32, y: 32}, true)
    input = new Input(ragnar)