(function() {
  var googl, io;

  googl = require("goo.gl");

  googl.setKey("AIzaSyBxnkRXgec4V_oOnx5zqJKDVpQI-x_G4R0");

  io = require('socket.io');

  exports.shortenURL = function(url, sessionID) {
    googl.shorten(url, function(shortUrl) {
      var server;
      server = require("./server");
      server.io.sockets["in"](sessionID).emit("urlShortened", {
        shortURL: shortUrl.id
      });
    });
  };

}).call(this);
