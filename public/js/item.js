class Item {
    constructor(id) {
        this.id = id;
        this.name = `item-${map.name}-${id}`;
        const { objects } = map.json.layers.filter(l => l.name === 'Attributes')[0];
        const items = objects.filter(o => o.type === 'item');
        const [ item ] = items.filter(i => i.id === id);
        [this.data] = window.gameItems.filter(gi => parseInt(item.properties.id, 10) === gi.id);
        const { x, y } = item;
        this.location = { x, y };

        if (!this.sprite) {
            const loader = new Phaser.Loader(game);
            loader.image(this.name, `/image/items/item_${this.data.sprite}.png`);
            loader.onLoadComplete.addOnce(this.onImageLoad.bind(this), this);
            loader.start();
        }
    }

    onImageLoad() {
        this.sprite = game.add.sprite(this.location.x, this.location.y, this.name);
        map.itemLayer.add(this.sprite);
    }
}