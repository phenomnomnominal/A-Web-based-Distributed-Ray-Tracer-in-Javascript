(function() {
  var Db, Server, createRendersCollection, db, io, mongo, open;

  io = require('socket.io');

  mongo = require("mongodb");

  Server = mongo.Server;

  Db = mongo.Db;

  db = null;

  createRendersCollection = function() {
    db.createCollection("renders", {
      safe: true
    }, function(error, collection) {
      if (error) {
        console.log("Error: ", error.message);
      } else {
        console.log("Collection created: ", collection);
      }
    });
  };

  open = function(callback) {
    var server;
    server = new Server("localhost", 27017, {
      autoconnect: true
    });
    db = new Db("renderDB", server, {});
    db.open(function(error, connection) {
      if (error) console.log("Error: ", error.message);
      if (!error) {
        console.log("Connected to renderDB");
        callback();
      }
    });
  };

  exports.init = function() {
    open(createRendersCollection);
  };

  exports.insert = function(toInsert) {
    db.collection("renders", function(error, collection) {
      if (error) console.log("Error: ", error.message);
      if (!error) {
        console.log(collection);
        collection.insert(toInsert, {
          safe: true
        }, function(error, result) {
          if (error) console.log("Error: ", error.message);
          if (!error) console.log("Success: ", result);
        });
      }
    });
  };

  exports.find = function(renderId, sessionID) {
    db.collection("renders", function(error, collection) {
      if (error) console.log("Error: ", error.message);
      if (!error) {
        collection.findOne({
          uuid: renderId
        }, function(err, render) {
          var server;
          if (error) console.log("Error: ", error.message);
          if (!error) {
            server = require("./server");
            server.io.sockets["in"](sessionID).emit("gotRender", {
              render: render
            });
            console.log(render);
          }
        });
      }
    });
  };

}).call(this);
