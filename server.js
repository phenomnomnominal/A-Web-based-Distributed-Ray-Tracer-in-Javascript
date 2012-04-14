
/* 
Module dependencies
*/

(function() {
  var Session, express, init, io, parseCookie, url;

  express = require("express");

  url = require("url");

  io = require("socket.io");

  parseCookie = require("connect").utils.parseCookie;

  Session = require('connect').middleware.session.Session;

  init = function(route, handle) {
    var initSocket, onRequest, server, store;
    onRequest = function(request, response) {
      var pathname;
      pathname = url.parse(request.url).pathname;
      request.setEncoding("utf8");
      route(handle, request.sessionID, pathname, response, request.body);
    };
    initSocket = function() {
      io.configure(function() {
        io.set('authorization', function(data, accept) {
          if (data.headers.cookie) {
            data.cookie = parseCookie(data.headers.cookie);
            data.sessionID = data.cookie['express.sid'];
            data.sessionStore = store;
            store.get(data.sessionID, function(err, session) {
              if (err || !session) {
                accept('Error', false);
              } else {
                data.session = new Session(data, session);
                accept(null, true);
              }
            });
          } else {
            accept("No cookie transmitted.", false);
          }
        });
        io.sockets.on("connection", function(socket) {
          console.log(io.transports[socket.id].name);
          console.log("A socket with sessionID " + socket.handshake.sessionID + " connected!");
          socket.join(socket.handshake.sessionID);
          socket.emit("connected", {
            connection: true
          });
          socket.on("confirmConnected", function(data) {
            console.log(data);
          });
        });
        io.sockets.on("disconnect", function(socket) {
          return console.log("A socket with sessionID " + socket.handshake.sessionID + " disconnected!");
        });
      });
    };
    server = module.exports = express.createServer();
    io = io.listen(server);
    server.listen(3000);
    initSocket();
    server.io = io;
    store = new express.session.MemoryStore;
    /* 
    Server Configuration
    */
    server.configure(function() {
      server.set("views", "" + __dirname + "/views");
      server.set("view engine", "jade");
      server.use(express.logger());
      server.use(express.bodyParser());
      server.use(express.cookieParser());
      server.use(express.session({
        secret: "phenomnomnominal",
        key: "express.sid",
        id: new Date(),
        store: store
      }));
      server.use(express.methodOverride());
      server.use(server.router);
      server.use("/public", express.static("" + __dirname + "/public"));
      server.use("/test", express.static("" + __dirname + "/test"));
      server.use(express.errorHandler({
        dumpExceptions: true,
        showStack: true
      }));
    });
    server.get("/", function(req, res) {
      onRequest(req, res);
    });
    server.get("/test", function(req, res) {
      onRequest(req, res);
    });
    server.get("/render", function(req, res) {
      onRequest(req, res);
    });
    server.get("/master", function(req, res) {
      onRequest(req, res);
    });
    server.post("/upload", function(req, res) {
      onRequest(req, res);
    });
    server.post("/getRender", function(req, res) {
      onRequest(req, res);
    });
    console.log("Express server listening on port " + (server.address().port) + " in " + server.settings.env + " mode");
  };

  exports.init = init;

}).call(this);
