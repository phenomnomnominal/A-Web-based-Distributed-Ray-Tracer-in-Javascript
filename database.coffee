io = require('socket.io')
mongo = require("mongodb")

Server = mongo.Server
Db = mongo.Db
db = null

createRendersCollection = ->
    db.createCollection("renders",
        safe:true
      , (error, collection) ->
          if error
            console.log("Error: ", error.message)
          else
            console.log("Collection created: ", collection)
          return
    )
    return

open = (callback) ->
  	server = new Server("localhost", 27017, 
      autoconnect: true
    )
    db = new Db("renderDB", server, {});
    db.open((error, connection) ->
      if error
        console.log("Error: ", error.message)
      if not error
        console.log("Connected to renderDB")
        callback()
        return
    )
    return

exports.init = ->
    open(createRendersCollection)
    return
    
exports.insert = (toInsert) ->
    db.collection("renders", (error, collection) ->
      if error
        console.log("Error: ", error.message)
      if not error
        console.log(collection)
        collection.insert(toInsert, safe: true, (error, result) ->
          if error
            console.log("Error: ", error.message)
          if not error
            console.log("Success: ", result)
          return
        )
      return
    )
    return

exports.find = (renderId, sessionID) ->
    db.collection("renders", (error, collection) ->
      if error
        console.log("Error: ", error.message)
      if not error
        collection.findOne({uuid: renderId}, (err, render) ->
          if error
            console.log("Error: ", error.message)
          if not error
            server = require("./server")
            server.io.sockets.in(sessionID).emit("gotRender", 
              render: render
            )
            console.log(render)
          return
        )
      return
    )
    return