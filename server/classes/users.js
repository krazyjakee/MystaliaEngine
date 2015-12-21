'use strict';

class Users{

  constructor(){
    var users = users_db.where("@cid >= 0");
    this.users = [];

    console.log('Loading ' + users.length() + ' users...');
    if(users.length()){
      for(let user in users.items){
        this.users.push(new User(user.key));
      }
    }
    console.log('Done.');
  }

  new(cb){
    this.users.push(new User(false, cb));
  }

  get(key){
    console.log('Getting ' + key + '...')
    for(let user of this.users){
      if(user.key == key){
        return user;
      }
    }
    return false;
  }

}

module.exports = new Users();
