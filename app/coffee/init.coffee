$(window).load ->
  # Maps are made by "Tiled", see how to structure new maps on the wiki.
  # Unlike other classes, the map class is used for all maps and is not just a single instance.
  window.map = new Map()

  # Load a map first, followed by anything else map related.
  map.load 'test', ->
    ragnar = new Character 'ragnar', 'ragnar', { x: 32, y: 32 }, true
    input = new Input ragnar