### 
Module dependencies 
###
express = require("express")
url = require("url")
io = require("socket.io")
parseCookie = require("connect").utils.parseCookie
Session = require('connect').middleware.session.Session;


init = (route, handle) ->
  onRequest = (request, response) ->
    pathname = url.parse(request.url).pathname
    request.setEncoding "utf8"
    route(handle, request.sessionID, pathname, response, request.body)
    return
    
  initSocket = ->
    io.configure(->
      io.set('authorization', (data, accept) ->
        if data.headers.cookie
          data.cookie = parseCookie(data.headers.cookie)
          data.sessionID = data.cookie['express.sid']
          data.sessionStore = store;
          store.get(data.sessionID, (err, session) ->
            if err or !session
              accept('Error', false)
            else
              data.session = new Session(data, session)
              accept(null, true)
            return
          )
        else
          accept("No cookie transmitted.", false)
        return
      )
      io.sockets.on("connection", (socket) ->
        console.log(io.transports[socket.id].name)
        console.log("A socket with sessionID #{ socket.handshake.sessionID } connected!")
        socket.join(socket.handshake.sessionID)
        socket.emit("connected",
          connection: true
        )
        socket.on("confirmConnected", (data) ->
          console.log(data)
          return
        )
        return
      )
      io.sockets.on("disconnect", (socket) ->
        console.log("A socket with sessionID #{ socket.handshake.sessionID } disconnected!")
      )
      return
    )
    return

  server = module.exports = express.createServer()
  io = io.listen(server)
  server.listen(3000)
  initSocket()
  server.io = io
  
  store = new express.session.MemoryStore
  
  ### 
  Server Configuration 
  ###
  server.configure ->
    server.set "views", "#{ __dirname }/views"
    server.set "view engine", "jade"
    server.use express.logger()
    server.use express.bodyParser()
    server.use express.cookieParser()
    server.use express.session(
      secret: "phenomnomnominal"
      key: "express.sid"
      id: new Date()
      store: store
    )
    server.use express.methodOverride()
    server.use server.router
    server.use("/public", express.static("#{ __dirname }/public"))
    server.use("/test", express.static("#{ __dirname }/test"))
    server.use express.errorHandler(
      dumpExceptions: true
      showStack: true
    )
    return
    
  server.get("/", (req, res) ->
      onRequest(req, res)
      return
  )
  
  server.get("/test", (req, res) ->
      onRequest(req, res)
      return
  )
  
  server.get("/render", (req, res) ->
      onRequest(req, res)
      return
  )
  
  server.get("/master", (req, res) ->
      onRequest(req, res)
      return
  )
  
  server.post("/upload", (req, res) ->
      onRequest(req, res)
      return
  )
  
  server.post("/getRender", (req, res) ->
      onRequest(req, res)
      return
  )
  
  console.log "Express server listening on port #{ server.address().port } in #{ server.settings.env } mode"   
  
  return

exports.init = init