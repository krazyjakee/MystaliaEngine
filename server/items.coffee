fs = require('fs')
path = require('path')
md5 = require('md5')
extend = require('extend')
Maps = require('./maps')

GLOBAL.disabledItems = []
itemStore = []
shopStore = []

if itemStore = readDataFile 'items'
  itemStore = itemStore.items
  console.log "#{itemStore.length} items loaded!"
else
  console.log "Please create/update an items data file."

if shopStore = readDataFile 'shops'
  shopStore = shopStore.shops
  console.log "#{shopStore.length} shops loaded!"
else
  console.log "Please create/update a shops data file."

module.exports = 

  itemStore: itemStore

  shopStore: shopStore

  checkStatus: (x, y, mapName) ->
    itemHash = md5.digest_s(x + y + mapName)
    if disabledItems[itemHash]
      { disabled: true, hash: itemHash }
    else
      { disabled: false, hash: itemHash }

  onMap: (mapName) -> # check the items on the map
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
        if user.items[item.id] # if the user has had this item before
          if user.items[item.id].count < 999 # if the user owns less than 1000
            user.items[item.id].count++ 
        else
          user.items[item.id] =  # add it to the user inventory
            count: 1
            order: 0
            equipped: false

        disabledItems[status.hash] = true
        i = clone(item)
        setTimeout ->
          disabledItems[status.hash] = false
          io.to(user.map).emit 'addMapItem', i
        , item.properties.interval
        io.to(user.map).emit 'removeMapItem', i
        for itemStoreItem in itemStore when itemStoreItem.id is i.id # get the full item details from the item store
          itemStoreItem.count = user.items[i.id].count
          return itemStoreItem
    false

  shopAt: (user, shopId) -> # the user and the id of the shop requested
    itemSet = []
    selectedShop = false
    mapData = Maps.get(user.map) # check the user map for available shops
    objectLayer = layer for layer in mapData.layers when layer.type is "objectgroup"
    for object in objectLayer.objects when object.type is "shop"
      if parseInt(object.properties.id) is shopId # if it has the requested id
        for shop in Items.shopStore when shop.id is shopId # get the shop
          selectedShop = shop # save it
          for trade in shop.trades # loop through available shop trades
            shopItems = trade.itemIn.concat(trade.itemOut) # merge all trade items into temp variable
            for shopItem in shopItems # loop through
              itemSet.push(item) for item in Items.itemStore when item.id is shopItem.id # and save the full item details
    return { shop: selectedShop, items: itemSet }


  shopTrade: (shopId, tradeIndex, user) ->
    for shop in Items.shopStore when shop.id is shopId # get the shop
      trade = shop.trades[tradeIndex] # get the trade
      mustHaves = trade.itemIn # the required items
      willGets = trade.itemOut # the reward items
      for mustHave in mustHaves # loop through all required items
        if user.items[mustHave.id] # if the user has any of this item
          if user.items[mustHave.id].count >= mustHave.count # and it is the required amount or more
            user.items[mustHave.id].count -= mustHave.count # remove the item from their inventory
            for willGet in willGets # loop through all reward items
              if user.items[willGet.id] # if the user has ever had the new item
                user.items[willGet.id].count += willGet.count # update the count
              else
                user.items[willGet.id] = # else add it to the user inventory
                  count: 1
                  order: 0
                  equipped: false
          else
            return false # if user does not have enough
        else
          return false # if user does not have any
    return user.items # return the new user items

