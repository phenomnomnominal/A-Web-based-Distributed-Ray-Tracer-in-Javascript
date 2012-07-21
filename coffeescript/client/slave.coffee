# *slave.coffee* contains client-side code for communicating with the
# server as a rendering **`slave`**. A device which acts as a **`slave`** has no
# control over render settings and simply performs computation and
# reports the results back to the [**`master`**](master.html).

# ___
# ## Constants:

# Some constants are required for this script:

# * **`LOCATION`** - *IP Address location for the server*
LOCATION = 'http://127.0.0.1'

# ___
# ## Initialisation:

# When the `document` is ready, options for a **[WebSocket][]**
# connection are initialised and the socket connection is made
# between the client and the server.
#
# <!--- URLs -->
# [websocket]: http://www.websocket.org/ "WebSocket"
$(document).ready ->
  socketOptions =
    'connect timeout': 500
    'reconnect': true
    'reconnection delay': 500
    'reopen delay': 600
    'max reconnection attempts': 10
  socket = io.connect LOCATION, socketOptions
  
  # The **[WebSocket][]** waits to hear back from the server that the
  # connection has occured before replying to the server with
  # confirmation.
  #
  # <!--- URLs -->
  # [websocket]: http://www.websocket.org/ "WebSocket"
  socket.on 'connected', (data) ->
    
    # Once the connection is confirmed, event-listeners for other
    # expected **[WebSocket][]** messages are created, such as:
    #
    # <!--- URLs -->
    # [websocket]: http://www.websocket.org/ "WebSocket"
    socket.emit 'confirmConnection', connection: 'confirmed'

    # * *'gotRender'* - *handle the received rendering operation.*
    socket.on 'gotRender', (data) ->
      $('#infoReport').text data.render.sceneDescription
    
    # The render **[UUID][]** is extracted from the URL string (the last 36
    # characters) and POSTed to */getRender*.
    #
    # <!--- URLs -->
    # [uuid]: http://en.wikipedia.org/wiki/Universally_unique_identifier "UUID"
    url = window.location.href
    uuidFromURL = url.substring(url.length - 36)
    getRenderObj = renderId: uuidFromURL
    $.ajax
      contentType: 'application/json'
      data: JSON.stringify getRenderObj
      type: 'POST'
      url: '/getRender'