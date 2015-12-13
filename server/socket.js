'use strict';

module.exports = function(socket) {
  socket.on('test', () => { socket.emit('test', 'testvalue') })
};