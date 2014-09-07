Maps = require('./maps')

module.exports = (socket) ->

  socket.on 'ping', ->
    socket.emit 'ping', 'ping'

  socket.on 'auth', (auth) ->
    id = socket.id
    auth = Users.find({ auth: auth })
    if auth = auth[0]
      Users.usersX[id] = auth
      socket.emit 'auth', Users.safeUserObject(auth)
    else
      socket.emit 'auth', false


  socket.on 'changeMap', (name) ->
    id = socket.id
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
          username: user.username

        socket.leave map
        io.to(map).emit 'heroLeave', user.username
        socket.join name
        io.to(name).emit 'heroJoin', user.username

        for k, user of Users.usersX
          if user.map is name
            socket.emit 'heroJoin', user.username

  socket.on 'move', (newLocation) ->
    id = socket.id
    if user = Users.usersX[id]
      user.x = newLocation.x / 32
      user.y = newLocation.y / 32
      io.to(user.map).emit 'move', { username: user.username, x: user.x, y: user.y }

  socket.on 'queryHero', (username) ->
    user = Users.find { username: username }
    user = Users.safeUserObject(user[0])
    socket.emit 'queryHero', user

  socket.on 'disconnect', ->
    id = socket.id
    user = Users.usersX[id]
    io.to(user.map).emit 'heroLeave', user.username
    delete Users.usersX[id]