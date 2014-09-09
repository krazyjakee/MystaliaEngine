fs = require('fs')
path = require('path')
GLOBAL.mapStore = {}

module.exports =

  get: (name) ->
    if mapStore[name]
      return mapStore[name]
    else
      file = path.resolve("server/maps/#{name}.json")
      if fs.existsSync(file)
        mapData = fs.readFileSync file, { encoding: 'utf-8' }
        mapData = eval "(#{mapData})"
        mapStore[name] = mapData
        return mapData
      else
        false

  hasAccessToMap: (map, dest, x, y) ->
    access = false
    newX = x
    newY = y
    return { x: newX, y: newY } if map is dest
    return false unless @get(dest)

    if mapData = @get(map)

      if y is 0 and mapData.properties.North is dest
        newY = mapData.height-1
        access = true
      if x is mapData.width-1 and mapData.properties.East is dest
        newX = 0
        access = true
      if y is mapData.height-1 and mapData.properties.South is dest
        newY = 0
        access = true
      if x is 0 and mapData.properties.West is dest
        newX = mapData.width-1
        access = true

      objectLayer = layer for layer in mapData.layers when layer.type is "objectgroup"
      for object in objectLayer.objects when object.type is "door"
        if object.properties.Map is dest
          destination = object.properties.Destination.split('x')
          newX = destination[0]
          newY = destination[1]
          access = true
    if access
      { x: newX, y: newY }
    else
      false

  getMapList: ->
    mapList = []
    dirPath = "server/maps"
    try
      files = fs.readdirSync(dirPath)
    catch e
      return

    if files.length > 0
      i = 0
      while i < files.length
        mapList.push files[i].replace('.json','')

    mapList