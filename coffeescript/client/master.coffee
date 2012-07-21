# *master.coffee* contains the client-side code for uploading and
# initialising a rendering operation. The user-interface requires
# access to certain **[HTML5][]** APIs:
#
# * **[File][]**
#
# * **[FileReader][]**
#
# * **[FileList][]**
#
# <!--- URLs -->
# [html5]: http://html5.org/ "HTML5"
# [file]: http://www.w3.org/TR/FileAPI/#dfn-file/ "File API"
# [filereader]: http://www.w3.org/TR/FileAPI/#dfn-filereader/ "FileReader API"
# [filelist]: http://www.w3.org/TR/FileAPI/#dfn-filelist/ "FileList API"

# If the browser doesn't have the required APIs, an error message is
# displayed and the page doesn't do anything.
if not window.File or not window.FileReader or not window.FileList
  alert '''The required APIs (File, FileReader and FileList) are not fully
           supported by this browser.'''
# If the APIs are available, the rest of the functionality is initialised.
else
  # ___
  # ## Constants:

  # Some constants are required for this script:
 
  # * **`LOCATION`** - *IP Address location for the server*
  LOCATION = 'http://127.0.0.1'

  # * **`PORT`** - *Port for* **[WebSocket][]** *connections*
  #
  # <!--- URLs -->
  # [websocket]: http://www.websocket.org/ "WebSocket"
  PORT = 3000
  
  # ___
  # ## File Event Handler Functions:
  
  # ### <section id='hfr'>*handleFileRead*:</section>
  # > **`handleFileRead`** first converts the *.dae* file from XML
  # > to JSON using the **[xml2json][]** **[jQuery][]** plugin.
  #
  # > If the converstion generates a valid JavaScript object,
  # > we then generate a **[UUID][]** with **[uuid.js][]**, create the link
  # > URL and POST the render data and URL to the server.
  #
  # <!--- URLs -->
  # [xml2json]: http://www.fyneworks.com/jquery/xml-to-json/ "xml2json Plugin"
  # [jquery]: http://www.jquery.com "jQuery"
  # [uuid]: http://en.wikipedia.org/wiki/Universally_unique_identifier "UUID"
  # [uuid.js]: https://github.com/LiosK/UUID.js "uuid.js library"
  handleFileRead = (readerOutput) ->
    renderJSON = $.xml2json readerOutput, true
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
    else throw new Error '''UI Error: The XML to JSON conversion returned no
                            JSON data.'''
  
  # ### <section id='hfd'>*handleFileDrop*:</section>
  # > **`handleFileDrop`** looks at the file (or files) that have
  # > been dropped by the user, selects the first one and
  # > checks that it is a **[COLLADA][]** file with the extension
  # > *.dae*. If it is, the file is passed to the [**`handleFileRead`**](#hfr)
  # > function for parsing, otherwise an error is thrown.
  #
  # <!--- URLS -->
  # [collada]: http://www.collada.org/ "COLLADA"
  handleFileDrop = (e) ->
    e.stopPropagation()
    e.preventDefault()
    if e.dataTransfer.files.length >= 1
      file = e.dataTransfer.files[0]
    if file
      if file.name.substring(file.name.length - 4, file.name.length) is '.dae'
        reader = new FileReader()
        reader.onload = (e) ->
          handleFileRead e.target.result
        reader.readAsText file
        e.success = true
      else throw new Error 'UI Error: The file dropped is not a COLLADA file.'
    else throw new Error 'UI Error: No file dropped.'

  # ### <section id='hdo'>*handleDragOver*:</section>
  # > **`handleDragOver`** is called whenever the user drags a
  # > file over the `<#fileDrop>` element. It sets the
  # > `dropEffect` of the drop event to *'copy'*.
  handleDragOver = (e) ->
    e.stopPropagation()
    e.preventDefault()
    e.dataTransfer.dropEffect = 'copy'
    
  # ___
  # ## Initialisation:
  
  # When the `document` is ready, options for a **[WebSocket][]**
  # connection are initialised and the connection is made between
  # the client and the server.
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
      
      # * *'urlShortened'* - *display the shortened URL which links to
      # the newly created rendering operation*
      socket.on 'urlShortened', (data) ->
        $('#infoReport').text data.shortURL
    
    # Finally, the file event handler functions are attached to the
    # `<#fileDrop>` element.
    fileDrop = $('#fileDrop').get 0
    if fileDrop
      fileDrop.ondragover = handleDragOver
      fileDrop.ondrop = handleFileDrop

  # ___
  # ## Exports:

  # The [**`handleFileRead`**](#hfr), [**`handleFileDrop`**](#hfd)
  # and [**`handleDragOver`**](#hdo) functions are added to the global
  # `root` object.
  root = exports ? this
  root.master =
    handleFileRead: handleFileRead
    handleFileDrop: handleFileDrop
    handleDragOver: handleDragOver