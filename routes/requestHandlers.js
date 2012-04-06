(function() {
  var querystring;

  querystring = require("querystring");

  exports.master = function(response) {
    console.log("Request to handler 'master' was called.");
    response.render("index", {
      title: "Master"
    });
    response.end();
  };

  exports.slave = function(response) {
    console.log("Request to handler 'slave' was called.");
    response.render("index", {
      title: "Slave"
    });
    response.end();
  };

  exports.test = function(response) {
    console.log("Request to handle 'test' was called.");
    response.render("test", {
      title: "Testing",
      layout: false
    });
    response.end();
  };

  exports.upload = function(response, postData) {
    console.log("Request to handler 'upload' was called.");
    response.render("index", {
      title: "Upload",
      postData: querystring.parse(postData).text
    });
    response.end();
  };

}).call(this);
