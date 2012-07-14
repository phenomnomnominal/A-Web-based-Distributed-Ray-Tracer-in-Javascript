# *server.coffee* sets up the server to recieve requests and provide responses, as well as [**WebSocket**](http://www.websocket.org/) communication with the client.
# ___

# ## Requires:
# Functionality in *database.coffee* requires access to the following [node.js](http://nodejs.org/) modules:

# * [`express`](http://expressjs.com/) - *High performance [**node.js**](http://nodejs.org/) framework*
express = require 'express'
# * [`url`](http://nodejs.org/api/url.html) - *URL resolution and parsing*
url = require 'url'
# * [`io`](http://socket.io/) - *Cross-browser [**WebSockets**](http://www.websocket.org/) for realtime applications*
io = require 'socket.io'
# * [`cookie`](https://github.com/shtylman/node-cookie) - *Cookie parsing and serialisation*
cookie = require 'cookie'
# * [**`Session`**](http://www.senchalabs.org/connect/middleware-session.html) - *Session data creation*
Session = (require 'connect').middleware.session.Session;
# ___

# ## Functions:

# ### <section id='init'>*InitialiseServer*:</section>
# > **`InitialiseServer`** performs all server configuration, including request handling, session handling and [**WebSocket**](http://www.websocket.org/) configuration.
InitialiseServer = (route, handle) ->
  # > **`onRequest`** is called whenever a `GET` or `POST` request is received from a client.
  # > It extracts the filepath, session information, and `POST` data from the request and forwards the information to the [**`route`**](router.html#route) function.
  onRequest = (request, response) ->
    pathname = (url.parse request.url).pathname
    request.setEncoding 'utf8'
    route handle, pathname, response, request.sessionID, request.body
  
  # > **`initialiseSocket`** configures the [**WebSocket**](http://www.websocket.org/) communication by attaching event listeners for incoming connections from clients. Session data is attached to the created [**WebSocket**](http://www.websocket.org/) so that messages can be sent to specific clients.
  initialiseSocket = ->
    sio.configure ->
      sio.set 'authorization', (data, accept) ->
        if data.headers.cookie
          data.cookie = cookie.parse data.headers.cookie
          data.sessionID = data.cookie['express.sid']
          data.sessionStore = store;
          store.get data.sessionID, (err, session) ->
            if err or !session
              accept 'Error', false
            else
              data.session = new Session(data, session)
              accept null, true      
        else
          accept 'No cookie transmitted.', false
      sio.sockets.on 'connection', (socket) ->
        console.log sio.transports[socket.id].name
        console.log "A socket with sessionID #{ socket.handshake.sessionID } connected!"
        socket.join socket.handshake.sessionID
        socket.emit 'connected',
          connection: true
        socket.on 'confirmConnected', (data) ->
          console.log data
      sio.sockets.on 'disconnect', (socket) ->
        console.log "A socket with sessionID #{ socket.handshake.sessionID } disconnected!"
  
  # > First, the server object is created and [**socket.io**](http://socket.io/) is pointed towards the server, which is listening for connections on port 3000. A [**`MemoryStore`**](http://expressjs.com/guide.html#session-support) is initialised for session handling.
  
  server = module.exports = express.createServer()
  sio = io.listen server
  server.listen 3000
  store = new express.session.MemoryStore
  
  # > Then **WebSocket** communication is initialised, and the **socket.io** object is attached to the global *exports* object.
  
  initialiseSocket()
  server.io = sio
  
  # > Finally the general server configuration is performed.
  
  server.configure ->
    server.set 'views', "#{ __dirname }/views"
    server.set 'view engine', 'jade'
    server.use '/client', express.static "#{ __dirname }/../client"
    server.use '/raytracer', express.static "#{ __dirname }/../raytracer"
    server.use '/testing', express.static "#{ __dirname }/../testing"
    server.use '/libraries', express.static "#{ __dirname }/../../libraries"
    server.use '/stylesheets', express.static "#{ __dirname }/../../stylesheets"
    server.use '/docs', express.static "#{ __dirname }/../../docs"
    server.use express.logger()
    server.use express.bodyParser()
    server.use express.cookieParser()
    server.use express.session
      secret: 'phenomnomnominal'
      key: 'express.sid'
      id: new Date()
      store: store
    server.use express.methodOverride()
    server.use server.router
    server.use express.errorHandler
      dumpExceptions: true
      showStack: true
    
  server.get '/*', (request, response) ->
    onRequest request, response

  server.post '/*', (request, response) ->
    onRequest request, response
  
  console.log "Server started on port #{ server.address().port } in #{ server.settings.env } mode"   
  
# ___
# ## Exports

# The [**`InitialiseServer`**](#init) function is added to the global `root` object.
root = exports ? this
root.init = InitialiseServer