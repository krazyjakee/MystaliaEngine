'use strict';

class User{

  constructor(key, cb){
    if(!key){
      this.setDefaults();
      crypto2.hash.sha256(config.salt + new Date(), function(err, hash){
        this.key = hash;
        this.save();
        if(cb){ cb(hash); }
      }.bind(this));
    }else{
      this.load(key);
    }
  }

  setDefaults(){

    if(!this.map){
      this.map = config.startMap;
    }

    if(!this.location){
      this.location = {
        x: config.startPosX,
        y: config.startPosY
      }
    }
  }

  save(){
    users_db.upsert({
      key: this.key,
      name: this.name,
      map: this.map,
      location: this.location
    }, 'key', this.key);
    users_db.save();
  }

  load(key){
    let user = users_db.where({key: key});
    if(user.length){
      for(let prop in user){
        this[prop] = user[prop];
      }
    }
  }

  profile(){
    return {
      name: this.name,
      map: this.map,
      location: this.location
    }
  }

}

module.exports = User;
