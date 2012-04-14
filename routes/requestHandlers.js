(function() {
  var database, querystring, urlShorten;

  querystring = require("querystring");

  database = require("../database");

  urlShorten = require("../urlShorten");

  exports.master = function(sessionID, response) {
    response.render("master", {
      title: "Master"
    });
  };

  exports.test = function(sessionID, response) {
    response.render("test", {
      layout: false
    });
  };

  exports.render = function(sessionID, response) {
    console.log("Request to handler 'render' was called.");
    response.render("index", {
      title: "Slave"
    });
  };

  exports.getRender = function(sessionID, response, getRender) {
    console.log("Request to handler 'getRender' was called.");
    database.find(getRender.renderId, sessionID);
  };

  exports.upload = function(sessionID, response, renderObject) {
    console.log("Request to handler 'upload' was called.");
    urlShorten.shortenURL(renderObject.url, sessionID);
    database.insert(renderObject);
  };

}).call(this);
