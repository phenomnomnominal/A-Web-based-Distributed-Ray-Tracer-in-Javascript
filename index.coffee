database = require("./database")
router = require("./router")
requestHandlers = require("./routes/requestHandlers")
server = require("./server")

handle = 
  "/": requestHandlers.master
  "/master": requestHandlers.master
  "/getRender": requestHandlers.getRender
  "/render": requestHandlers.render
  "/test": requestHandlers.test
  "/upload": requestHandlers.upload

server.init(router.route, handle)
database.init()