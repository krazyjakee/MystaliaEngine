class Map
  
  tmx2html: false
  attributes: false
  json: false

  constructor: ->
    @tmx2html = new tmx2html()

  load: (id, callback) ->
    that = @
    @tmx2html.load id, '/map/'+id, (json, name) ->
      that.json = json
      $('#game').html that.tmx2html.render(id)
      that.getAttributes json
      callback(json)

  getAttributes: (json) ->
    attributes = {}
    objectLayer = layer for layer in json.layers when layer.type is "objectgroup"
    attributes[range.type] = [] for range in objectLayer.objects
    for range in objectLayer.objects
      w = range.width / 32
      h = range.height / 32
      x = range.x
      y = range.y
      for i in [0...h]
        for j in [0...w]
          location = { x: x + (j * 32), y: y + (i * 32) }
          attributes[range.type].push @locationToId location

    @attributes = attributes

  # Turn a tile location ({ x: 64, y: 0 }) into a tile id (2)
  locationToId: (location) ->
    x = Math.floor(location.x / 32)
    y = Math.floor(location.y / 32)
    w = @json.width
    id = x

    id += w for i in [0...y]
    id

  getTileAttribute: (id) ->
    for k, v of @attributes
      for t in v
        if t is id
          return k
    false

