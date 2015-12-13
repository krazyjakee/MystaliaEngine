var game = false,
map = false;

var preload = function(){
  
}

var create = function(){
  map = new Map();
}

var update = function(){

}

$(window).load(function() {

  game = new Phaser.Game(32*16, 32*10, Phaser.AUTO, 'game', { preload: preload, create: create, update: update });

  window.socket = io();
  socket.on('connect', function() {
    socket.emit('test', 'testvalue');
    socket.on('test', function(test) {
      log("Connected to websocket: " + new Date());
    });
  });
});

var log = function(msg){
  $('.console').append("<p>" + msg + "</p>");
}

var setmap = function(e){
  var mapName = ['start', 'temple', 'test-east', 'test-north', 'test-south', 'test-west'][e];
  map.load(mapName);
  log("Loaded Map: " + mapName);
}