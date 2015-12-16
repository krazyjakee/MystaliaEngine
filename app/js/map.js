'user strict';

class Map {

	constructor(){
		this.load('start', { x: 288, y: 224 });
	}

	load(name, startPosition = false){
		if(!name){ return; }
		this.destroy();
		let loader = new Phaser.Loader(game);
		this.name = name;
		this.startPosition = startPosition;
		this.layers = [];
		this.blocks = [];
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
				this.layers.push(newMap.createLayer(layer.name));
			}else{
				for(let obj of layer.objects){
					let bmp = game.add.bitmapData(obj.width, obj.height);
					bmp.fill(255, 0, 0, 0.1)
    			let block = game.add.sprite(obj.x, obj.y, bmp);
    			game.physics.enable(block, Phaser.Physics.ARCADE);
    			block.body.immovable = true;
    			block.tileType = obj.type;
    			block.tileProperties = obj.properties;
    			this.blocks.push(block);
				}
			}
		}
		this.map = newMap;
		this.onLoad();
	}

	onLoad(){
		hero = new Hero('ragnar', { x: this.startPosition.x, y: this.startPosition.y });
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

	next(colDirection){
		let mapProps = this.json.data.properties;
		let spriteLoc = { x: hero.sprite.x, y: hero.sprite.y }
		let newDirection = false;
		switch(colDirection){
			case "left":
				newDirection = mapProps.West;
				this.load(mapProps.West, { x: game.width - 32, y: spriteLoc.y });
				break;
			case "right":
				newDirection = mapProps.East;
				this.load(mapProps.East, { x: 0, y: spriteLoc.y });
				break;
			case "up":
				newDirection = mapProps.North;
				this.load(mapProps.North, { x: spriteLoc.x, y: game.height - 32 });
				break;
			case "down":
				newDirection = mapProps.South;
				this.load(mapProps.South, { x: spriteLoc.x, y: 0 });
				break;
		}
		if(newDirection){
			hero.destroy();
		}
	}

	tileAction(block){
		switch(block.tileType){
      case "block":
        return true;
        break;
      case "door":
        hero.destroy();
        let newLocation = block.tileProperties.Destination.split('x');
        this.load(block.tileProperties.Map, { x: parseInt(newLocation[0]*32), y: parseInt(newLocation[1]*32) });
        return true;
    }
	}
}
