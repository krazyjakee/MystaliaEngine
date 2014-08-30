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
          that.users.save userData.username, userData, (err) ->
            console.log "Created user " + userData.username
            callback { username: userData.username }
      else
        callback { error: "Error" }

  login: (userData, callback) ->
    salt = "wd40"
    password = md5.digest_s(salt + userData.password)
    @find { username: userData.username, password: password }, (results) ->
      if results
        callback { login: true }
      else
        callback { error: "Failed to authenticate." }

  find: (userData, callback) ->
    @users.find userData, (err, results) ->
      if results.length is 0
        callback(false)
      else if Object.keys(results).length
        callback(results)
      else
        callback(false)

  validate: (userData, callback) ->
    if userData
      if userData.password
        salt = "wd40"
        userData.password = md5.digest_s(salt+userData.password)
        if userData.username
          if userData.username.length > 3
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

module.exports = Users