var preload = function(){
  game.load.tilemap('start', '/map/start', null, Phaser.Tilemap.TILED_JSON);
  game.load.image('freeTileset', '/tileset/tileset.png');
  game.load.image('benches', '/tileset/benches.png');
  game.load.image('plants', '/tileset/plants.png');
}

var create = function(){
  var map = game.add.tilemap('start');
  map.addTilesetImage('freeTileset');
  map.addTilesetImage('benches');
  map.addTilesetImage('plants');

  map.createLayer('Ground');
  map.createLayer('Mask');
  map.createLayer('Fringe');
}

var game = false;

$(window).load(function() {
  game = new Phaser.Game(32*16, 32*10, Phaser.AUTO, 'game', { preload: preload, create: create });

  window.socket = io();
  socket.on('connect', function() {
    socket.emit('test', 'testvalue');
    socket.on('test', function(test) {
      $('.console').append("<p>Connected " + new Date() + "</p>");
    });
  });
});