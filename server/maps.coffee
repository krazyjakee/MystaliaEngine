fs = require('fs')
path = require('path')

module.exports =

  get: (name) ->
    file = path.resolve("server/maps/#{name}.json")
    if fs.existsSync(file)
      fs.readFileSync file, { encoding: 'utf-8' }
    else
      false

  hasAccessToMap: (map, dest, x, y) ->
    access = false
    newX = x
    newY = y
    return { x: newX, y: newY } if map is dest

    if mapData = @get(map)
      mapData = eval "("+mapData+")"

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