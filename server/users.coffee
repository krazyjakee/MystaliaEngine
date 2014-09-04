extend = require('extend')
nStore = require('nstore')
nStore = nStore.extend(require('nstore/query')())
md5 = require('md5')

class Users

  users: false
  constructor: ->
    @users = nStore.new 'server/data/users.db'
    console.log 'Users Initiated'

  create: (userData, callback) ->
    that = @
    @validate userData, (results, userData) ->
      if userData
        if results
          console.log "Already exists"
          callback { error: "Username already registered." }
        else
          defaults =
            map: 'start'
            x: 8
            y: 5
            level: 1
            hp: 10
            mp: 10
            xp: 0
          extend false, userData, defaults
          that.users.save userData.username, userData, (err) ->
            console.log "Created user " + userData.username
            callback { username: userData.username }
      else
        callback { error: "Error" }

  login: (userData, callback) ->
    that = @
    salt = "wd40"
    password = md5.digest_s(salt + userData.password)
    @find { username: userData.username, password: password }, (results) ->
      if results
        console.log userData.username + " logged in!"
        that.getPlayerStatus userData.username, callback
      else
        callback { error: "Failed to authenticate." }

  find: (userData, callback) ->
    @users.find userData, (err, results) ->
      if results
        if results.length is 0
          callback(false)
        else if Object.keys(results).length
          callback(results)
        else
          callback(false)
      else
        callback(false)

  list: (callback) ->
    @users.all (err, results) ->
      for r in results
        console.log r.username

  validate: (userData, callback) ->
    if userData
      if userData.password
        salt = "wd40"
        userData.password = md5.digest_s(salt+userData.password)
        if userData.username
          if userData.username.length > 2
            if userData.username.length < 15
              @find { username: userData.username }, (results) -> 
                callback(results, userData)
            else
              callback "Username is too long."
          else
            callback "Username is too short."
        else
          callback "A username is required."
      else
        callback "A password is required."

  getPlayerStatus: (username, callback) ->
    @find { username: username }, (results) ->
      player = results[username]
      json =
        login: true
        map: player.map
        x: player.x
        y: player.y
        hp: player.hp
        mp: player.mp
        xp: player.xp
        level: player.level
      callback json

module.exports = Users