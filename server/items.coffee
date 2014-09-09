fs = require('fs')
path = require('path')
md5 = require('md5')
extend = require('extend')
Maps = require('./maps')

GLOBAL.itemTimers = []

file = path.resolve("server/data/items")
if fs.existsSync(file)
  itemst = fs.readFileSync(file, { encoding: 'utf-8' })
  GLOBAL.itemStore = eval("(" + itemst + ")").items
else
  false

module.exports = 
  onMap: (mapName) ->
    mapData = Maps.get(mapName)
    mapData = eval "("+mapData+")"
    mapItems = []
    objectLayer = layer for layer in mapData.layers when layer.type is "objectgroup"
    for object in objectLayer.objects when object.type is "item"
      id = parseInt(object.properties.id)
      interval = object.properties.interval
      itemHash = md5.digest_s(object.x + object.y + mapName)
      for item in itemStore when item.id is id
        tempItem = extend false, object, item
        mapItems.push tempItem
    mapItems