(function() {
  var fs, path, route;

  fs = require("fs");

  path = require("path");

  route = function(handle, sessionID, pathname, response, postData) {
    var contentType, extension;
    extension = path.extname(pathname);
    switch (extension) {
      case ".js":
        contentType = "text/javascript";
        break;
      case ".css":
        contentType = "text/css";
    }
    if (typeof handle[pathname] === 'function') {
      handle[pathname](sessionID, response, postData);
    } else if (contentType) {
      path.exists("." + pathname, function(exists) {
        if (exists) {
          fs.readFile("." + pathname, function(error, content) {
            if (error) {
              response.writeHead(500);
            } else {
              response.writeHead(200, {
                "Content-Type": contentType
              });
            }
          });
        } else {
          response.writeHead(404, {
            "Content-Type": "text/plain"
          });
          response.write("404 Not found");
        }
      });
    } else {
      response.writeHead(404, {
        "Content-Type": "text/plain"
      });
      response.write("404 Not found");
    }
  };

  exports.route = route;

}).call(this);
