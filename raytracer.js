
/* 
Module dependencies
*/

(function() {
  var express, raytracer, routes;

  express = require("express");

  routes = require("./routes");

  raytracer = module.exports = express.createServer();

  /* 
  Configuration
  */

  raytracer.configure(function() {
    raytracer.set("views", __dirname + "/views");
    raytracer.set("view engine", "jade");
    raytracer.use(express.bodyParser());
    raytracer.use(express.cookieParser());
    raytracer.use(express.session({
      secret: "phenomnomnominal",
      id: new Date()
    }));
    raytracer.use(express.methodOverride());
    raytracer.use(raytracer.router);
    raytracer.use(express.static(__dirname + "/public"));
  });

  raytracer.configure("development", function() {
    raytracer.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });

  raytracer.configure("production", function() {
    raytracer.use(express.errorHandler());
  });

  /* 
  Routes
  */

  raytracer.get("/", routes.index);

  raytracer.listen(3000);

  console.log("Express server listening on port %d in %s mode", raytracer.address().port, raytracer.settings.env);

}).call(this);
