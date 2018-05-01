import fs from 'fs-extra';
import path from 'path';
import Item from './item';

export default class GameMap {
  constructor(filename) {
    this.filename = filename;
  }

  async initiate(io) {
    const rawText = await fs.readFile(path.resolve(`server/maps/${this.filename}`), 'utf8');
    const json = JSON.parse(rawText);
    this.data = json;
    this.setupItems();

    this.room = io.of(`/map/${this.name()}`);
    this.room.on('connection', (socket) => {
      socket.emit('mapData', {
        items: this.getItems(),
      });
    });
  }

  setupItems() {
    const { objects } = this.data.layers.filter(l => l.name === 'Attributes')[0];
    const items = objects.filter(o => o.type === 'item');
    this.items = items.map(i => new Item(i, this.room));
  }

  getItems() {
    return this.items.filter(item => item.spawned).map(item => item.id);
  }

  name() {
    return this.data.properties.name;
  }
}
