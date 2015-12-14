'user strict';

class Hero extends Character {

	controls(){

		if(!this.sprite){ return; }

		let a = game.input.keyboard.isDown(Phaser.Keyboard.A);
		let d = game.input.keyboard.isDown(Phaser.Keyboard.D);
		let w = game.input.keyboard.isDown(Phaser.Keyboard.W);
		let s = game.input.keyboard.isDown(Phaser.Keyboard.S);

		if(!a && !d && !w && !s){
			this.sprite.animations.stop();
			return;
		}

		if (a) {
      this.sprite.body.x -= 2;
      if(!w && !s){
      	this.sprite.animations.play('left');
      }
    } else if (d) {
      this.sprite.body.x += 2;
      if(!w && !s){
	      this.sprite.animations.play('right');
	    }
    }

    if (w) {
      this.sprite.body.y -= 2;
      this.sprite.animations.play('up');
    } else if (s) {
      this.sprite.body.y += 2;
      this.sprite.animations.play('down');
    }
	}

}