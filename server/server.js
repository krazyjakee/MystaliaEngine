import express from 'express';
import bodyParser from 'body-parser';
import path from 'path';
import LocallyDb from 'locallydb';
import config from './config';
import socket from './socket';
import Users from './classes/users';

const app = express();
const db = new LocallyDb('./server/data');
const usersDb = db.collection('users');

const users = new Users(usersDb);

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

app.get('/', (req, res) => { res.sendFile('index.html3'); });
app.get('/register', (req, res) => { users.new((key) => { res.send(key); }); });
app.get('/favicon.ico', (req, res) => { res.send('Not Found.', 404); });
app.get('/map/:name', (req, res) => { res.sendFile(path.resolve(`server/maps/${req.params.name}.json`)); });

const server = require('http').Server(app).listen(config.port);

const io = require('socket.io').listen(server);

io.on('connection', socket(users));
console.log(`Listening on port ${config.port}...`);
