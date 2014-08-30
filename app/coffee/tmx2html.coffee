class tmx2html

  constructor: ->
    $('head').append '<style id="tmx2html"></style>'

  store: {}
  tilesetStore: {}

  load: (name, file = false, callback = false) ->
    that = @
    unless @store[name]
      if file
        $.getJSON file, (json) ->
          that.store[name] = json
          for tileset in json.tilesets
            that.tilesetStore[name] = that.addTileset(tileset.name, tileset.image)
          callback(json, name)
        true
    else
      callback @store[name], name

  render: (name) ->
    json = @store[name]
    classNames = html = ""
    layerWidth = json.layers[0].width * 32
    for tileset in json.tilesets
      classNames += "tileset-#{tileset.name}"

    for layer in json.layers
      html += "<div class='layer layer-#{layer.name}' style='width: #{layerWidth}px;'>"
      if layer.data?
        for tile, index in layer.data
          if loc = @tileNumberToLoc(tile, json.tilesets[0])
            newX = loc.x * 32
            newY = loc.y * 32
            html += "<div class='tile #{layer.name} tile-#{index} #{classNames}' style='background-position: -#{newX}px -#{newY}px;'></div>"
          else
            html += "<div class='tile #{layer.name} tile-#{index}'></div>"
      html += "</div>"

    $(html)

  addTileset: (name, image) ->
    className = "tileset-#{name}"
    $('#tmx2html').append ".#{className}{ background-image: url('#{image}');"
    className

  tileNumberToLoc: (number, tileset) ->
    if number > 0
      x = y = 0
      imageWidth = tileset.imagewidth / 32 - 1

      for i in [1...number]
        ++x
        if x > imageWidth
          ++y
          x = 0

      { x: x, y: y }
    else
      false