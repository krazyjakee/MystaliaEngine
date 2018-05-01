import express from 'express';
import bodyParser from 'body-parser';
import http from 'http';
import socketIo from 'socket.io';
import config from './config';
import Users from './classes/users';
import Maps from './classes/maps';
import items from './data/items.json';

const app = express();
const users = new Users();
const maps = new Maps();

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With');
  if (req.method === 'OPTIONS') {
    res.send(200);
  } else {
    next();
  }
});

app.use(bodyParser.urlencoded({
  extended: true,
}));

app.use(express.static('public'));

app.get('/', (req, res) => { res.sendFile('index.html'); });
app.get('/register', (req, res) => { users.new((key) => { res.send(key); }); });
app.get('/favicon.ico', (req, res) => { res.send('Not Found.', 404); });

const init = async () => {
  const server = http.Server(app).listen(config.port);
  const io = socketIo.listen(server);
  await maps.initiate(io);

  io.on('connection', (socket) => {
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
        socket
          .emit('map', maps.get(name).data);
      })
      .on('items', () => {
        socket.emit('items', items.items);
      });
  });

  console.log(`Listening on port ${config.port}...`);
};

init();
