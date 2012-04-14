googl = require("goo.gl")
googl.setKey "AIzaSyBxnkRXgec4V_oOnx5zqJKDVpQI-x_G4R0"
io = require('socket.io')

exports.shortenURL = (url, sessionID) ->
    googl.shorten(url, (shortUrl) ->
        server = require("./server")
        server.io.sockets.in(sessionID).emit("urlShortened", 
          shortURL: shortUrl.id
        )
        return
    )
    return