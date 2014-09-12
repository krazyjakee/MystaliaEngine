Maps = require('./maps')

module.exports = (socket) ->

  socket.on 'ping', ->
    socket.emit 'ping', 'ping'

  socket.on 'auth', (auth) ->
    if auth
      id = socket.id
      auth = Users.find({ auth: auth })
      if auth = auth[0]
        Users.usersX[id] = auth
        socket.emit 'auth', auth.map
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

        socket.emit 'mapItems', Items.onMap(name)

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

  socket.on 'chat', (msg) ->
    user = Users.usersX[socket.id]
    io.to(user.map).emit 'chat', { username: user.username, msg: msg }

  socket.on 'action', ->
    user = Users.usersX[socket.id]
    if item = Items.itemAt(user)
      socket.emit 'addUserItem', item

  socket.on 'userItems', ->
    user = Users.usersX[socket.id]
    filteredItemStore = []
    for uItem, i in user.items
      for sItem in Items.itemStore when sItem.id is i
        filteredItemStore.push sItem
    socket.emit 'userItems',
      inventory: user.items
      itemStore: filteredItemStore

  socket.on 'shopTrade', (data) ->
    user = Users.usersX[socket.id]
    user.items = newItems if newItems = Items.shopTrade(data.shopId, data.tradeIndex, user)


  socket.on 'disconnect', ->
    id = socket.id
    user = Users.usersX[socket.id]
    if user
      io.to(user.map).emit 'heroLeave', user.username
      Users.update(user.username, user)
      delete Users.usersX[id]