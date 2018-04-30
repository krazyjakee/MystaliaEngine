'user strict';

class Map {

  constructor() {
    this.onDataReceived = this.onDataReceived.bind(this);
  }

  load(name, startPosition) {
    if (!name) { return; }
    this.destroy();
    this.name = name;
    this.startPosition = startPosition;

    const cachedData = window.game.cache.getTilemapData(this.name);
    if (cachedData) {
      this.json = cachedData.data;
      requestAnimationFrame(() => this.onTilesetsLoad());
    } else {
      window.socket
        .on('map', this.onDataReceived)
        .emit('map', name);
    }
  }

  onDataReceived(mapData) {
    window.game.cache.addTilemap(this.name, null, mapData);
    this.json = mapData;
    const loader = new Phaser.Loader(game);
    for (const tileset of this.json.tilesets) {
      loader.image(tileset.name, tileset.image);
    }
    loader.onLoadComplete.addOnce(this.onTilesetsLoad, this);
    loader.start();
  }

  onTilesetsLoad() {
    const newMap = game.add.tilemap(this.name);
    for (const tileset of this.json.tilesets) {
		  newMap.addTilesetImage(tileset.name);
    }
    for (const layer of this.json.layers) {
      if (layer.type == 'tilelayer') {
        if (layer.name == 'Player') {
          this.playerLayer = game.add.group();
        }
        this.layers.push(newMap.createLayer(layer.name));
      } else {
        for (const obj of layer.objects) {
          const bmp = game.add.bitmapData(obj.width, obj.height);
          // bmp.fill(255, 0, 0, 0.1)
    			const block = game.add.sprite(obj.x, obj.y, bmp);
    			game.physics.enable(block, Phaser.Physics.ARCADE);
    			block.body.immovable = true;
    			block.tileType = obj.type;
    			block.tileProperties = obj.properties;
    			this.blocks.push(block);
        }
      }
    }
    $('.map-title').html(this.name);
    hero = new Hero('ragnar', { x: this.startPosition.x, y: this.startPosition.y });
  }

  destroy() {
    if (this.layers) {
      for (const layer of this.layers) {
        layer.destroy();
      }
    }
    
    this.layers = [];
    this.blocks = [];
    
    window.socket
      .off('map', this.onDataReceived);
  }

  next(colDirection) {
    const mapProps = this.json.properties;
    const spriteLoc = { x: hero.sprite.x, y: hero.sprite.y };
    let newDirection = false;
    switch (colDirection) {
      case 'left':
        newDirection = mapProps.west;
        this.load(mapProps.west, { x: game.width - 32, y: spriteLoc.y });
        break;
      case 'right':
        newDirection = mapProps.east;
        this.load(mapProps.east, { x: 0, y: spriteLoc.y });
        break;
      case 'up':
        newDirection = mapProps.north;
        this.load(mapProps.north, { x: spriteLoc.x, y: game.height - 32 });
        break;
      case 'down':
        newDirection = mapProps.south;
        this.load(mapProps.south, { x: spriteLoc.x, y: 0 });
        break;
    }
    if (newDirection) {
      hero.destroy();
    }
  }

  tileAction(block) {
    switch (block.tileType) {
      case 'block':
        return true;
        break;
      case 'door':
        hero.destroy();
        const newLocation = block.tileProperties.destination;
        this.load(block.tileProperties.Map, { x: newLocation.x, y: newLocation.y });
        return true;
    }
  }
}
