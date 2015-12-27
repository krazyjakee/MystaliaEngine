'use strict';

class Users{

  constructor(){
    let users = users_db.where("@cid >= 0");
    this.users = [];

    console.log('Loading ' + users.length() + ' users...');
    if(users.length()){
      for(let user of users.items){
        if(user.key){
          this.users.push(new User(user.key));
        }
      }
    }
    console.log('Done.');
  }

  new(cb){
    this.users.push(new User(false, cb));
  }

  get(key){
    console.log('Getting ' + key + '...');
    for(let user of this.users){
      if(user.key == key){
        return user;
      }
    }
    return false;
  }

}

module.exports = new Users();
