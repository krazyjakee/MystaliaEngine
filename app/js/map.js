'user strict';

class Map {

	constructor(cb = false){
		this.load('start');
		this.callback = cb;
	}

	load(name){
		this.destroy();
		let loader = new Phaser.Loader(game);
		this.name = name;
		this.layers = [];
		loader.tilemap(name, '/map/' + name, null, Phaser.Tilemap.TILED_JSON);
		loader.onLoadComplete.addOnce(this.onJSONLoad, this);
		loader.start();
	}

	onJSONLoad(){
		this.json = game.cache.getTilemapData(this.name);

		let loader = new Phaser.Loader(game);
		for(var tileset of this.json.data.tilesets){
			loader.image(tileset.name, tileset.image);
		}
		loader.onLoadComplete.addOnce(this.onTilesetsLoad, this);
		loader.start();
	}

	onTilesetsLoad(){
		let newMap = game.add.tilemap(this.name);
		for(var tileset of this.json.data.tilesets){
		  newMap.addTilesetImage(tileset.name);
		}
		for(var layer of this.json.data.layers){
			if(layer.type == "tilelayer"){
				if(layer.name == "Player"){
					this.playerLayer = game.add.group();
				}
				
				let newLayer = newMap.createLayer(layer.name);
				newLayer.resizeWorld();
				this.layers.push(newLayer);

				if(layer.name == "Mask"){
					// to finish use a tilelayer for blocking instead of an object layer.
				}
			}
		}
		this.map = newMap;
		if(this.callback){
			this.callback();
		}
	}

	destroy(){
		if(this.layers){
			for(var layer of this.layers){
				layer.destroy();
			}
		}
		this.name = false;
		this.map = false;
		this.json = false;
		this.layers = false;
	}
}