extend = require('extend')
md5 = require('md5')

class Users

  db: new locallydb('server/data')
  users: false
  usersX: [] # User data stored in memory.
  constructor: ->

    @users = @db.collection('users')
    console.log 'Users Initiated'

  create: (userData) ->
    that = @
    userData = @validate userData
    if userData.username
      defaults =
        map: 'start'
        x: 8
        y: 5
        level: 1
        hp: 10
        mp: 10
        xp: 0
        auth: ""
      extend false, userData, defaults
      @users.insert userData
      @users.save()
      console.log "Created user " + userData.username
      { username: userData.username }
    else
      { error: userData }

  login: (userData) ->
    userData.password = md5.digest_s("wd40" + userData.password)
    results = @find userData
    if results
      userData.auth = md5.digest_s(new Date('u') + userData.username)
      @update userData.username, userData
      { auth: userData.auth }
    else
      { error: "Failed to authenticate." }

  find: (userData) ->
    results = @users.where userData
    if results
      if results.length is 0
        false
      else if Object.keys(results).length
        results
      else
        false
    else
      false

  list: (callback) -> @users.items

  update: (username, userData) ->
    @users.update @users.where({ username: username })[0].cid, userData
    @users.save()

  validate: (userData) ->
    if userData.password
      userData.password = md5.digest_s("wd40" + userData.password)
      if userData.username
        if userData.username.length > 2
          if userData.username.length < 15
            existing = @find { username: userData.username }
            if existing
              "User already Exists."
            else
              userData
          else
            "Username is too long."
        else
          "Username is too short."
      else
        "A username is required."
    else
      "A password is required."

  safeUserObject: (userData) ->
    json = 
      map: userData.map
      x: userData.x
      y: userData.y
      level: userData.level
      hp: userData.hp
      mp: userData.mp
      xp: userData.xp
      cid: userData.cid

module.exports = Users