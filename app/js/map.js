'user strict';

class Map {

	constructor(){
		this.load('start');
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
				this.layers.push(newMap.createLayer(layer.name));
			}
		}
		this.map = newMap;
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