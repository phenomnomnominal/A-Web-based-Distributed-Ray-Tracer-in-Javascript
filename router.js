(function() {
  var fs, path, route;

  fs = require("fs");

  path = require("path");

  route = function(handle, pathname, response, postData) {
    var contentType, extension;
    console.log(pathname);
    console.log("About to route a request for " + pathname);
    extension = path.extname(pathname);
    switch (extension) {
      case ".js":
        contentType = "text/javascript";
        break;
      case ".css":
        contentType = "text/css";
    }
    if (typeof handle[pathname] === 'function') {
      handle[pathname](response, postData);
    } else if (contentType) {
      path.exists("." + pathname, function(exists) {
        if (exists) {
          return fs.readFile("." + pathname, function(error, content) {
            if (error) {
              response.writeHead(500);
              return response.end();
            } else {
              response.writeHead(200, {
                "Content-Type": contentType
              });
              return response.end(content, "utf-8");
            }
          });
        } else {
          response.writeHead(404, {
            "Content-Type": "text/plain"
          });
          response.write("404 Not found");
          return response.end();
        }
      });
    } else {
      console.log("No request handler found for " + pathname);
      response.writeHead(404, {
        "Content-Type": "text/plain"
      });
      response.write("404 Not found");
      response.end();
    }
  };

  exports.route = route;

}).call(this);
