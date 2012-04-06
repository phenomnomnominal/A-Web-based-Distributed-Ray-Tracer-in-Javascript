(function() {
  var handle, requestHandlers, router, server;

  server = require("./server");

  router = require("./router");

  requestHandlers = require("./routes/requestHandlers");

  handle = {
    "/": requestHandlers.master,
    "/master": requestHandlers.master,
    "/test": requestHandlers.test,
    "/slave": requestHandlers.slave,
    "/upload": requestHandlers.upload
  };

  server.init(router.route, handle);

}).call(this);
