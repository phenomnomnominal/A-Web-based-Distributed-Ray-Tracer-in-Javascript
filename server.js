
/* 
Module dependencies
*/

(function() {
  var express, init, url;

  express = require("express");

  url = require("url");

  init = function(route, handle) {
    var onRequest, server;
    onRequest = function(request, response) {
      var pathname, postData;
      postData = "";
      pathname = url.parse(request.url).pathname;
      request.setEncoding("utf8");
      request.addListener("data", function(postDataChunk) {
        postData += postDataChunk;
        console.log("Received POST data chunk '" + postDataChunk + "'.");
      });
      request.addListener("end", function() {
        route(handle, pathname, response, postData);
      });
    };
    server = module.exports = express.createServer(onRequest).listen(3000);
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
        id: new Date()
      }));
      server.use(express.methodOverride());
      server.use(server.router);
      server.use(express.static("" + __dirname + "/public"));
    });
    server.configure(function() {
      server.use(express.errorHandler({
        dumpExceptions: true,
        showStack: true
      }));
    });
    server.configure(function() {
      server.use(express.errorHandler());
    });
    console.log("Express server listening on port " + (server.address().port) + " in " + server.settings.env + " mode");
  };

  exports.init = init;

}).call(this);
