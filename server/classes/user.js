import crypto2 from 'crypto2';
import config from '../config';

class User {
  constructor(key, cb, db) {
    this.db = db;
    if (!key) {
      this.setDefaults();
      this.setup(cb);
    } else {
      this.load(key);
    }
    return this;
  }

  async setup(cb) {
    const hash = await crypto2.hash.sha256(config.salt + new Date());
    this.key = hash;
    this.save();
    console.log(`Registered new user ${hash}`);
    if (cb) { cb(hash); }
  }

  setDefaults() {
    if (!this.map) {
      this.map = config.startMap;
    }

    if (!this.location) {
      this.location = {
        x: config.startPosX,
        y: config.startPosY,
      };
    }
  }

  save() {
    this.db.upsert({
      key: this.key,
      name: this.name,
      map: this.map,
      location: this.location,
    }, 'key', this.key);
    this.db.save();
    this.load(this.key);
  }

  load(key) {
    const user = this.db.where({ key });
    if (user.items.length) {
      user.items.forEach((prop) => {
        this[prop] = user.items[0][prop];
      });
    }
  }

  profile() {
    return {
      name: this.name,
      map: this.map,
      location: this.location,
    };
  }
}

module.exports = User;
