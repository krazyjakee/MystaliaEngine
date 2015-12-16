'user strict';

class Hero extends Character {

	controls(){

		if(!this.sprite){ return; }

		let a = game.input.keyboard.isDown(Phaser.Keyboard.A) || cursors.left.isDown;
		let d = game.input.keyboard.isDown(Phaser.Keyboard.D) || cursors.right.isDown;
		let w = game.input.keyboard.isDown(Phaser.Keyboard.W) || cursors.up.isDown;
		let s = game.input.keyboard.isDown(Phaser.Keyboard.S) || cursors.down.isDown;

		if(!a && !d && !w && !s){
			this.sprite.animations.stop();
			return;
		}

		if (a) {
      if(!w && !s){
      	this.sprite.animations.play('left');
      	this.direction = 'left';
      }
      if(this.checkCollide(-2, 0)){ return; }
      this.sprite.x -= 2;
    } else if (d) {
      if(!w && !s){
	      this.sprite.animations.play('right');
	      this.direction = 'right';
	    }
      if(this.checkCollide(2, 0)){ return; }
      this.sprite.x += 2;
    }

    if (w) {
      this.sprite.animations.play('up');
      this.direction = 'up';
      if(this.checkCollide(0, -2)){ return; }
      this.sprite.y -= 2;
    } else if (s) {
      this.sprite.animations.play('down');
      this.direction = 'down';
      if(this.checkCollide(0, 2)){ return; }
      this.sprite.y += 2;
    }
	}

	checkCollide(x, y){
		x = this.sprite.x + x;
		y = this.sprite.y + y;

    let headHeight = 12;
    let armWidth = 8;

    let spriteGhost = {
      x: x + armWidth / 2,
      y: y + headHeight,
      width: this.sprite.width - armWidth,
      height: this.sprite.height - headHeight
    }

    let colDirection = this.collide(spriteGhost, { x: 0, y: 0, width: game.width - (armWidth / 2), height: game.height - headHeight });
    if(colDirection){
      map.next(colDirection);
      return true;
    }

		for(let block of map.blocks){
			if(!this.collide(spriteGhost, block)){
        return map.tileAction(block);
			}
		}
		return false;
	}

	collide(a, b){
		if(a.x > b.x + b.width){
      return "right";
    }
    if(a.x + a.width < b.x){
      return "left";
    }
    if(a.y > b.y + b.height){
      return "down";
    }
    if(a.height + a.y < b.y){
      return "up";
    }
    return false;
	}

  destroy(){
    this.sprite.destroy();
    this.sprite = false;
    this.name = false;
    this.location = false;
  }

}
