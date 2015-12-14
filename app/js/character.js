'user strict';

class Character {

	constructor(name){
		this.name = name;
		this.load();
	}

	load(){
		let loader = new Phaser.Loader(game);
		loader.spritesheet(this.name, 'sprite/' + this.name + '.png', 32, 32);
		loader.onLoadComplete.addOnce(this.onLoad, this);
		loader.start();
	}

	onLoad(){
		this.sprite = game.add.sprite(0, 0, this.name);
		this.sprite.animations.add('left', [3, 4, 5], 10, true);
		this.sprite.animations.add('down', [0, 1, 2], 10, true);
		this.sprite.animations.add('up', [9, 10, 11], 10, true);
		this.sprite.animations.add('right', [6, 7, 8], 10, true);
		this.sprite.frame = 1;
		game.physics.enable(this.sprite);
		this.sprite.body.setSize(32, 32, 0, 0);
    this.sprite.body.collideWorldBounds = true;
		map.playerLayer.add(this.sprite);
	}

}