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
			if(this.checkCollide(-2, 0)){ return; }
      this.sprite.body.x -= 2;
      if(!w && !s){
      	this.sprite.animations.play('left');
      	this.direction = 'left';
      }
    } else if (d) {
    	if(this.checkCollide(2, 0)){ return; }
      this.sprite.body.x += 2;
      if(!w && !s){
	      this.sprite.animations.play('right');
	      this.direction = 'right';
	    }
    } 

    if (w) {
    	if(this.checkCollide(0, -2)){ return; }
      this.sprite.body.y -= 2;
      this.sprite.animations.play('up');
      this.direction = 'up';
    } else if (s) {
    	if(this.checkCollide(0, 2)){ return; }
      this.sprite.body.y += 2;
      this.sprite.animations.play('down');
      this.direction = 'down';
    }
	}

	checkCollide(x, y){
		x = this.sprite.body.x + x;
		y = this.sprite.body.y + y;

		for(let block of map.blocks){
			let collide = this.collide({
				x: x,
				y: y,
				width: this.sprite.width,
				height: this.sprite.height
			}, block);

			if(collide){
				return true;
			}
		}
		return false;
	}

	collide(a, b){
		return a.x < b.x + b.width && a.x + a.width > b.x && a.y < b.y + b.height && a.height + a.y > b.y;
	}

}