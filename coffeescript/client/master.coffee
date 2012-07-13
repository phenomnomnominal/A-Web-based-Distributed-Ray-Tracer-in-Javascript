# *master.coffee* contains the client-side code for uploading and initialising a rendering operation. The user-interface requires access to certain [**HTML5**](http://html5.org/) APIs including:
#
# * [**File**](http://www.w3.org/TR/FileAPI/#dfn-file)
#
# * [**FileReader**](http://www.w3.org/TR/FileAPI/#dfn-filereader)
#
# * [**FileList**](http://www.w3.org/TR/FileAPI/#dfn-filelist)

# If the browser doesn't have the required APIs, an error message is displayed and the page doesn't do anything.
if not window.File or not window.FileReader or not window.FileList
  alert 'The File APIs are not fully supported in this browser.'
# If the APIs are available, the rest of the functionality is initialised:
else
  # ___
  # ## Constants:
  # ___

  # Some constants are required for this script:
 
  # * **LOCATION** - *IP Address location for the server.*
  LOCATION = 'http://127.0.0.1'

  # * **PORT** - *Port for [**WebSocket**](http://http://www.websocket.org/) connections.*
  PORT = 3000  
  
  # ___
  # ## File Event Handler Functions:
  # ___
  
  # ### *handleFileRead*:
  # > *'handleFileRead'* first converts the .dae file from XML to JSON using the [xml2json](http://www.fyneworks.com/jquery/xml-to-json/) jQuery plugin.
  #
  # > Provided a JavaScript object exists, we then generate a [***UUID***](http://en.wikipedia.org/wiki/Universally_unique_identifier) with [uuid.js](https://github.com/LiosK/UUID.js)), create the link URL and POST the render and URL to the server.
  handleFileRead = (readerOutput) ->
    renderJSON = $.xml2json readerOutput
    if renderJSON? and not $.isEmptyObject renderJSON
      uuid = UUID.genV1().toString()
      WEBSITE = "#{LOCATION}:#{PORT}/render?renderId="
      renderObject =
        url: WEBSITE + uuid
        uuid: uuid
        sceneDescription: JSON.stringify renderJSON
      $.ajax
        contentType: 'application/json'
        data: JSON.stringify renderObject
        type: 'POST'
        url: '/upload'
      return renderObject
    else
      throw new Error 'The XML to JSON converstion returned no JSON data'
  
  # ### *handleFileDrop*:
  # > *'handleFileDrop'* looks at the file (or files) that have been dropped by the user, selects the first one and checks if it is a [**COLLADA**](http://www.collada.org) file with the extension *'.dae'*. If it is, the file is passed to the *'handleFileRead'* function for parsing, otherwise an error is thrown.
  handleFileDrop = (e) ->
    e.stopPropagation() 
    e.preventDefault()
    if e.dataTransfer.files.length > 1
      file = e.dataTransfer.files[0]
    if file
      if file.name.substring(file.name.length - 4, file.name.length) is '.dae'
        reader = new FileReader()
        reader.onload = (e) ->
          handleFileRead e.target.result
        reader.readAsText file
        e.success = true
      else
        throw new Error "File dropped - not COLLADA"
    else
      throw new Error "No file dropped"

  # ### *handleFileDrop*:
  # > *'handleFileDrop'* is called whenever the user drags a file over the file dropzone and sets the drop effect to 'copy'.
  handleDragOver = (e) ->
    e.stopPropagation()
    e.preventDefault()
    e.dataTransfer.dropEffect = 'copy'
    
  # ___
  # ## Initialisation:
  # ___
  
  # When the document is ready, options for a [**WebSocket**](http://http://www.websocket.org/) connection are initialised and the connection is made between the client and the server. 
  $(document).ready ->    
    socketOptions =
      'connect timeout': 500
      'reconnect': true
      'reconnection delay': 500
      'reopen delay': 600
      'max reconnection attempts': 10
    socket = io.connect LOCATION, socketOptions

    # The [**WebSocket**](http://http://www.websocket.org/) waits to hear back from the server that the connection has occured, before replying to the server with confirmation.
    socket.on 'connected', (data) ->
      socket.emit 'confirmConnection', connection: 'confirmed'
      # Once the connection is confirmed, event-listeners for other expected [**WebSocket**](http://http://www.websocket.org/) messages are created, such as:

      # * **'urlShortened'** - display the shortened URL which links to the newly created rendering operation.
      socket.on 'urlShortened', (data) ->
        $('#infoReport').text data.shortURL
    
    # Finally, the file event handler functions are attached to the *'fileDrop'* element. 
    fileDrop = $('#fileDrop').get(0)
    if fileDrop
      fileDrop.ondragover = handleDragOver
      fileDrop.ondrop = handleFileDrop

  # ___
  # ## Exports
  # ___

  # The ***handleFileRead***, ***handleFileDrop*** and ***handleDragOver*** functions are added to the global *root* object.
  root = exports ? this
  root.globalFunctions = 
    handleFileRead: handleFileRead
    handleFileDrop: handleFileDrop
    handleDragOver: handleDragOver