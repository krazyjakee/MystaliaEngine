'use strict';

module.exports = function(socket) {

  socket.on('login', function(key){
    if(key){
      let login_user = Users.get(key);
      if(login_user){
        let profile = login_user.profile();
        socket.emit('login', profile);
        console.log(key + ' logged in.')
      }
    }
  });
};
