$(window).load ->
  # Maps are made by "Tiled", see how to structure new maps on the wiki.
  # Unlike other classes, the map class is used for all maps and is not just a single instance.
  window.map = new Map()

  window.socket = io()
  socket.on 'connect', ->
    socket.emit 'auth', window.localStorage['auth']
    socket.on 'auth', (auth) ->
      if auth
        socket.emit 'changeMap', auth.map
      else
        location.href = "/"
    socket.on 'changeMap', (result) ->
      if result.map
        # Load a map first, followed by anything else map related.
        map.load result.map, ->
          ragnar = new Character 'ragnar', 'ragnar', { x: result.x * 32, y: result.y * 32 }, true
          input = new Input ragnar

    socket.on 'disconnect', ->
      console.log('user disconnected')