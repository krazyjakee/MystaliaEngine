fs = require('fs')
express = require('express')
app = express()
bodyParser = require('body-parser')
sass = require("node-sass")
coffeem = require('coffee-middleware')
path = require('path')
GLOBAL.locallydb = require('locallydb')
u = require('./users')
GLOBAL.Users = new u()
socket = require('./socket')

GLOBAL.clone = (object) -> JSON.parse(JSON.stringify(object))

allowCrossDomain = (req, res, next) ->
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With')
  if 'OPTIONS' is req.method then res.send(200) else next()

flushSass = ->
  dirPath = "public/stylesheets"
  try
    files = fs.readdirSync(dirPath)
  catch e
    return
  if files.length > 0
    i = 0
    while i < files.length
      filePath = dirPath + "/" + files[i]
      if fs.statSync(filePath).isFile()
        fs.unlinkSync filePath
      i++
  console.log "CSS Cache Cleared"
  return
flushSass()

app.set 'views', 'app/views'
app.set 'view engine', 'jade'

app.use allowCrossDomain
app.use bodyParser.urlencoded()
app.use express.static('public')
app.use sass.middleware
  src: 'app'
  dest: 'public'
app.use coffeem
  src: 'app/coffee'
  compress: true
  bare: true

app.get '/', (req, res) -> res.render 'index'
app.get '/play', (req, res) -> res.render 'play'
app.get '/tileset/:resource', (req, res) -> res.sendFile path.resolve('app/image/tileset/' + req.params.resource)
app.get '/sprite/:resource', (req, res) -> res.sendFile path.resolve('app/image/sprite/' + req.params.resource)
app.get '/other/:resource', (req, res) -> res.sendFile path.resolve('app/image/other/' + req.params.resource)
app.get '/map/:name', (req, res) -> res.sendFile path.resolve('server/maps/' + req.params.name + '.json')

app.post '/register', (req, res) ->
  username = req.param 'username'
  password = req.param 'password'
  if username
    console.log username + " is attempting to register..."
    res.send Users.create({ username: username, password: password })
  else
    res.send { error: "No data received" }

app.post '/login', (req, res) ->
  username = req.param 'username'
  password = req.param 'password'
  if username
    res.send Users.login({ username: username, password: password })
    console.log "#{username} logged in!"
  else
    res.send { error: "No data received" }

config = require('./config')
server = require('http').Server(app).listen(config.port)
GLOBAL.io = require('socket.io').listen(server)
io.on 'connection', socket

GLOBAL.Items = require('./items')

console.log('Listening on port 80...')