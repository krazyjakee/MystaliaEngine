fs = require('fs')
path = require('path')
md5 = require('md5')
extend = require('extend')
Maps = require('./maps')

GLOBAL.disabledItems = []
GLOBAL.itemStore = []

file = path.resolve("server/data/items")
if fs.existsSync(file)
  itemst = fs.readFileSync(file, { encoding: 'utf-8' })
  itemStore = eval("(" + itemst + ")").items
else
  false

module.exports = 

  checkStatus: (x, y, mapName) ->
    itemHash = md5.digest_s(x + y + mapName)
    if disabledItems[itemHash]
      { disabled: true, hash: itemHash }
    else
      { disabled: false, hash: itemHash }

  onMap: (mapName) ->
    mapData = Maps.get(mapName)
    mapItems = []
    objectLayer = layer for layer in mapData.layers when layer.type is "objectgroup"
    for object in objectLayer.objects when object.type is "item"
      id = parseInt(object.properties.id)
      unless Items.checkStatus(object.x, object.y, mapName).disabled
        for item in itemStore when item.id is id
          tempObject = clone(object)
          tempItem = clone(item)
          mapItems.push extend(true, tempObject, tempItem)
    mapItems

  itemAt: (user) ->
    mapItems = Items.onMap user.map # get all available items on the users map
    # filter by items on the current user position
    for item in mapItems when (item.x / 32) is user.x and (item.y / 32) is user.y
      # check the status of that item
      status = Items.checkStatus(item.x, item.y, user.map)
      unless status.disabled # if it's not disabled
        user.items.push item.id # add it to the user inventory
        disabledItems[status.hash] = true
        console.log disabledItems
        i = clone(item)
        setTimeout ->
          disabledItems[status.hash] = false
          io.to(user.map).emit 'addItem', i
        , item.properties.interval
        io.to(user.map).emit 'removeItem', i

