import fs from 'fs-extra';
import path from 'path';
import GameMap from './map';

export default class Maps {
  constructor() {
    this.maps = [];
  }

  async initiate() {
    const files = await fs.readdir(path.resolve('./server/maps'));
    files.forEach((file) => {
      this.maps.push(new GameMap(file));
    });

    await Promise.all(this.maps.map(m => m.initiate()));
    console.log(`Loaded ${this.maps.length} maps.`);
    return true;
  }

  get(name) {
    return this.maps.filter(m => m.name() === name)[0];
  }
}
