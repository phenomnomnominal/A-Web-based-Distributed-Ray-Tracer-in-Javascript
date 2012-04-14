# When the window is ready, connect a WebSocket to 
# the server and retrieve the scene description that
# belongs to the render UUID.
$(window).ready(->
  
  # Connect WebSocket to server.
  socket = io.connect("http://127.0.0.1",
    "connect timeout": 500
    "reconnect": true
    "reconnection delay": 500
    "reopen delay": 600
    "max reconnection attempts": 10
  )
  
  # Add a listener for the "connected" message.
  socket.on("connected", (data) ->
    #  When the connection is made, respond with a confimation message.
    socket.emit("confirmConnection",
      connection: "confirmed"
    )
    
    # And add a listener for the "gotRender" message.
    socket.on("gotRender", (data) ->
      # When the render data is received, use it...
      $("#infoReport").text(data.render.sceneDescription)
      return
    )
    
    # Extract the render UUID from the URL string - (last 36 characters of the URL).
    getRenderObj = 
      renderId: window.location.href.substring(window.location.href.length - 36)
    
    # And then POST it to the server.
    $.ajax
        contentType: "application/json"
        data: JSON.stringify(getRenderObj)
        type: "POST"
        url: "/getRender"
    return
  )
  return
)