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
        if(!this.profile){
          if(profile){
            log("Logged in");
            $('#menupanel, #game-container').toggleClass('hide');
            this.profile = profile;
            window.game = new Phaser.Game(32*16, 32*10, Phaser.CANVAS, 'game', {
              preload: this.preload,
              create: this.create,
              update: this.update,
              render: this.render
            });
          }else{
            alert('Account not found!');
          }
        }
      }.bind(that));

    });
  }

  preload(){
    window.game.scale.scaleMode = Phaser.ScaleManager.USER_SCALE;
    window.game.scale.setUserScale(2, 2);
    window.game.renderer.renderSession.roundPixels = true;
    Phaser.Canvas.setImageRenderingCrisp(window.game.canvas);
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

var user_key = window.localStorage.getItem("user_key");
if(user_key){
  $('#code').val(user_key);
  $('#login').removeClass('hide');
}

$('#register').click(function(){
  $('#login').removeClass('hide');
  $.get('/register', (res) => {
    $('#code').val(res);
    $('#register').addClass('hide');
    window.localStorage.setItem("user_key", res);
  });
});

$('#login').click(function(){
  window.system = new Mystalia();
});
