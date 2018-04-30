import LocallyDb from 'locallydb';
import User from './user';

const db = new LocallyDb('./server/data');
const usersDb = db.collection('users');

export default class Users {
  constructor() {
    const users = usersDb.where('@cid >= 0');
    this.users = [];

    if (users.length()) {
      users.items.forEach((user) => {
        if (user.key) {
          this.users.push(new User(user.key, null, usersDb));
        }
      });
    }
    console.log(`Loaded ${users.length()} users.`);
  }

  new(cb) {
    this.users.push(new User(false, cb, usersDb));
  }

  get(key) {
    console.log(`Getting ${key}...`);
    return this.users.filter(user => user.key === key)[0] || null;
  }
}
