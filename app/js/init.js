'use strict';

var game = false,
map = false,
hero = false,
socket = io();

class Mystalia {

  constructor(){
    game = new Phaser.Game(32*16, 32*10, Phaser.AUTO, 'game', { preload: this.preload, create: this.create, update: this.update, render: this.render });

    socket.on('connect', function() {
      socket.emit('test', 'testvalue');
      socket.on('test', function(test) {
        log("Connected to websocket: " + new Date());
      });
    });
  }

  preload(){

  }

  create(){
    map = new Map();
  }

  update(){
    if(hero){
      hero.controls();
    }
  }

  render(){

  }

}

var log = function(msg){
  $('.console').append("<p>" + msg + "</p>");
}

var setmap = function(e){
  var mapName = ['start', 'temple', 'test-east', 'test-north', 'test-south', 'test-west'][e];
  map.load(mapName);
  log("Loaded Map: " + mapName);
}

var system = new Mystalia();
