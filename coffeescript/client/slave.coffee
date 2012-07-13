# *slave.coffee* contains client-side code for communicating with the server as a rendering *slave*. A device which acts as a *slave* has no control over render settings and simply performs computation and reports the results back to the *master*.

# ___
# ## Constants:
# ___

# Some constants are required for this script:

# * **`LOCATION`** - *IP Address location for the server.*
LOCATION = 'http://127.0.0.1'

# ___
# ## Initialisation:
# ___

# When the `document` is ready, options for a [**WebSocket**](http://http://www.websocket.org/) connection are initialised and the socket connection is made between the client and the server. 
$(document).ready ->
  socketOptions =
    'connect timeout': 500
    'reconnect': true
    'reconnection delay': 500
    'reopen delay': 600
    'max reconnection attempts': 10
  socket = io.connect LOCATION, socketOptions
  
  # The [**WebSocket**](http://http://www.websocket.org/) waits to hear back from the server that the connection has occured before replying to the server with confirmation.
  socket.on 'connected', (data) ->
    socket.emit 'confirmConnection', connection: 'confirmed'
    # Once the connection is confirmed, event-listeners for other expected [**WebSocket**](http://http://www.websocket.org/) messages are created, such as:

    # * *'gotRender'* - handle the recieved rendering operation.
    socket.on 'gotRender', (data) ->
      $('#infoReport').text data.render.sceneDescription
    
    # The render [**UUID**](http://en.wikipedia.org/wiki/Universally_unique_identifier) is extracted from the URL string (the last 36 characters and POSTed to */getRender*.
    getRenderObj = renderId: window.location.href.substring(window.location.href.length - 36)
    $.ajax
        contentType: 'application/json'
        data: JSON.stringify getRenderObj
        type: 'POST'
        url: '/getRender'