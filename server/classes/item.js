import itemData from '../data/items.json';

export default class Item {
  constructor(data, socket) {
    this.socket = socket;
    this.id = data.id;
    this.interval = parseInt(data.properties.interval, 10);
    [this.item] = itemData.items.filter(i => i.id === parseInt(data.properties.id, 10));
    this.spawned = true;
  }

  pickup() {
    const { id } = this;
    this.spawned = false;
    this.timer = setTimeout(() => {
      this.spawned = true;
      this.socket.emit('item', { id, spawned: true });
    }, this.interval);
    this.socket.emit('item', { id, spawned: false });
  }
}
