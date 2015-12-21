'use strict';

var fs = require('fs'),
express = require('express'),
app = express(),
bodyParser = require('body-parser'),
sass = require("node-sass-middleware"),
babel = require('babel-middleware'),
path = require('path'),
locallydb = require('locallydb'),
db = new locallydb('./server/data'),
socket = require('./socket');

GLOBAL.config = require('./config');
GLOBAL.crypto2 = require('crypto2');
GLOBAL.users_db = db.collection('users');

GLOBAL.User = require('./classes/user');
GLOBAL.Users = require('./classes/users');

var allowCrossDomain = function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With');
  if ('OPTIONS' === req.method) {
    res.send(200);
  } else {
    next();
  }
};

var flushSass = function() {
  var dirPath = "public/stylesheets";
  try {
    var files = fs.readdirSync(dirPath);
  } catch (_error) {
    e = _error;
    return;
  }
  if (files.length > 0) {
    var i = 0;
    while (i < files.length) {
      var filePath = dirPath + "/" + files[i];
      if (fs.statSync(filePath).isFile()) {
        fs.unlinkSync(filePath);
      }
      i++;
    }
  }
  console.log("CSS Cache Cleared");
};

flushSass();

app.set('views', path.resolve('app/views'));
app.set('view engine', 'jade');

app.use(allowCrossDomain);
app.use(bodyParser.urlencoded({
  extended: true
}));
app.use(express["static"]('public'));
app.use(sass({
  src: 'app',
  dest: 'public',
  babelOptions: {
    presets: ['es2015']
  }
}));
app.use('/js/', babel({
  srcPath: 'app/js'
}));

app.get('/', (req, res) => { res.render('index') });
app.get('/register', (req, res) => { Users.new(function(key){ res.send(key); })});
app.get('/favicon.ico', (req, res) => { res.send('Not Found.', 404) });
app.get('/tileset/:resource', (req, res) => { res.sendFile(path.resolve('app/image/tileset/' + req.params.resource)) });
app.get('/sprite/:resource', (req, res) => { res.sendFile(path.resolve('app/image/sprite/' + req.params.resource)) });
app.get('/other/:resource', (req, res) => { res.sendFile(path.resolve('app/image/other/' + req.params.resource)) });
app.get('/map/:name', (req, res) => { res.sendFile(path.resolve('server/maps/' + req.params.name + '.json')) });

var server = require('http').Server(app).listen(config.port);

GLOBAL.io = require('socket.io').listen(server);
io.on('connection', socket);
console.log("Listening on port " + config.port + "...");
