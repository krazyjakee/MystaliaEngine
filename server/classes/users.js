import User from './user';

export default class Users {
  constructor(db) {
    this.db = db;
    const users = db.where('@cid >= 0');
    this.users = [];

    console.log(`Loading ${users.length()} users...`);
    if (users.length()) {
      users.items.forEach((user) => {
        if (user.key) {
          this.users.push(new User(user.key, null, db));
        }
      });
    }
    console.log('Done.');
  }

  new(cb) {
    this.users.push(new User(false, cb, this.db));
  }

  get(key) {
    console.log(`Getting ${key}...`);
    return this.users.filter(user => user.key === key)[0] || null;
  }
}
