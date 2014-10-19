class World

  gameTime: 0

  gameTimeState: false

  gameTimer: false

  constructor: ->
    that = @
    @gameTimer = setInterval ->
      that.gameTime++
      that.checkTime()
    , 1000


  checkTime: ->
    gtMinutes = Math.floor(@gameTime / 60)
    if gtMinutes < Config.dayTime
      @sendNewTimeState "dayTime"
    else if gtMinutes is Config.dayTime
      @sendNewTimeState "eveningTime"
    else if gtMinutes < (Config.dayTime + Config.nightTime)
      @sendNewTimeState "nightTime"
    else if gtMinutes is (Config.dayTime + Config.nightTime)
      @sendNewTimeState "morningTime"
    else
      @gameTime = 0

  sendNewTimeState: (timeState) ->
    if @gameTimeState != timeState
      io.emit "timeState", timeState
      @gameTimeState = timeState


module.exports = World
