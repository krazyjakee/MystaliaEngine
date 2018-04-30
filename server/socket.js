export default ({ users, maps }) => (socket) => {
  socket
    .on('login', (key) => {
      if (key) {
        const loginUser = users.get(key);
        if (loginUser) {
          const profile = loginUser.profile();
          socket.emit('login', profile);
          console.log(`${key} logged in.`);
        } else {
          socket.emit('login', false);
        }
      }
    })
    .on('map', (name) => {
      socket.emit('map', maps.get(name).data);
    });
};
