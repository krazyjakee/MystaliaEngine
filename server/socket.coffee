module.exports = (socket) ->
  socket.on 'ping', ->
    socket.emit 'ping', 'ping'
  socket.on 'disconnect', ->
    false