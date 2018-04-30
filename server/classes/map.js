import fs from 'fs-extra';
import path from 'path';

export default class GameMap {
  constructor(filename) {
    this.filename = filename;
  }

  async initiate() {
    const rawText = await fs.readFile(path.resolve(`server/maps/${this.filename}`), 'utf8');
    const json = JSON.parse(rawText);
    this.data = json;
  }

  name() {
    return this.data.properties.name;
  }
}
