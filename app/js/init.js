'use strict';

var game = false,
map = false,
hero = false,
cursors = false;

class Mystalia {

  constructor(){
    window.socket = io();
    var that = this;
    socket.on('connect', function() {
      log("Connected to websocket: " + new Date());

      socket.emit('login', $('#code').val());
      socket.on('login', function(profile){
        this.profile = profile;
        window.game = new Phaser.Game(32*16, 32*10, Phaser.AUTO, 'game', { preload: this.preload, create: this.create, update: this.update, render: this.render });
      }.bind(that));

    });
  }

  preload(){

  }

  create(){
    cursors = game.input.keyboard.createCursorKeys();
    map = new Map();
    map.load(system.profile.map, system.profile.location);
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

$('#register').click(function(){
  $('#login').removeClass('hide');
  $.get('/register', (res) => { $('#code').val(res); });
});

$('#login').click(function(){
  $('#menupanel, #gamepanel').toggleClass('hide');
  window.system = new Mystalia();
});
