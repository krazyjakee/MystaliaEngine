class Map
  
  tmx2html: false
  attributes: false
  json: false
  items: false

  constructor: ->
    @tmx2html = new tmx2html()

  load: (id, callback) ->
    that = @
    @tmx2html.load id, '/map/'+id, (json, name) ->
      that.json = json
      $('#game').html that.tmx2html.render(id)
      that.getAttributes json
      callback(json)
      that.placeItems()

  changeMap: (direction) ->
    if newMap = @json.properties[direction]
      @items = false
      socket.emit 'changeMap', newMap
    false

  warpMap: (destination) ->
    socket.emit 'changeMap', destination
    false

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
          attributes[range.type].push
            id: @locationToId(location)
            properties: range.properties

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
        if t.id is id
          return k
    false

  placeItems: ->
    if @items
      for item in @items
        id = @locationToId item
        itemElem = $("<div class=\"tile item item-#{id}\"></div>").css
          "background-image": "url(/other/#{item.sprite}.png)"
          "background-position": "-#{item.offset.x}px -#{item.offset.y}px"
          left: item.x
          top: item.y
        itemElem.prependTo('.layer-Player')

  removeItem: (item) ->
    id = @locationToId item
    $(".item-#{id}").remove()

  addItem: (item) ->
    id = @locationToId item
    objectLayer = layer for layer in @json.layers when layer.type is "objectgroup"
    for rawItem in objectLayer.objects when rawItem.type is "item"
      if rawItem.x is item.x and rawItem.y is item.y
        itemElem = $("<div class=\"tile item item-#{id}\"></div>").css
          "background-image": "url(/other/#{item.sprite}.png)"
          "background-position": "-#{item.offset.x}px -#{item.offset.y}px"
          left: item.x
          top: item.y
        itemElem.prependTo('.layer-Player')

  setEffect: (name) ->
    if map.json.properties.Indoor and map.json.properties.Indoor is "1"
      Effects.none()
    else
      switch name
        when "nightTime" then Effects.dark()
        when "eveningTime" then Effects.lighter()
        when "dayTime" then Effects.none()
        when "morningTime" then Effects.lighter()
