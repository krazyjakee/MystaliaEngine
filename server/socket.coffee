Maps = require('./maps')

module.exports = (socket) ->

  socket.on 'ping', ->
    socket.emit 'ping', 'ping'

  socket.on 'auth', (auth) ->
    id = socket.clientId
    auth = Users.find({ auth: auth })
    if auth = auth[0]
      Users.usersX[id] = auth
      socket.emit 'auth', Users.safeUserObject(auth)
    else
      socket.emit 'auth', false


  socket.on 'changeMap', (name) ->
    id = socket.clientId
    if user = Users.usersX[id]
      x = user.x
      y = user.y
      map = user.map
      if newLocation = Maps.hasAccessToMap(map, name, x, y)
        user.map = name
        if user = Users.usersX[id]
          user.x = newLocation.x
          user.y = newLocation.y
        socket.emit 'changeMap',
          map: name
          x: newLocation.x
          y: newLocation.y

  socket.on 'move', (newLocation) ->
    id = socket.clientId
    if user = Users.usersX[id]
      user.x = newLocation.x / 32
      user.y = newLocation.y / 32

  socket.on 'disconnect', ->
    false