root = exports ? this

if window.File && window.FileReader && window.FileList && window.Blob 
#Provided the browser has the required file APIs  

  ###
  function handleFileRead
      This function takes any XML content from the uploaded file,
      converts it to a JSON string and POSTs it to the server.
  @param readerOutput -> Output from the file reading output
  @return null
  ###
  handleFileRead = (readerOutput) ->
    json = $.xmlToJSON(readerOutput) #Convert the .dae file from XML to JSON
    if json isnt undefined and json isnt null#Provided a JavaScript object exists, we POST it to the server.
      uuid = UUID.genV1().toString() #Generate a Universal Unique Identifier
      WEBSITE = "localhost:3000?render="
      renderObject =
	      urlToShorten: WEBSITE + uuid 
	      sceneDescription: JSON.stringify(json)
  	  	$.ajax
				    contentType: "application/json"
				 	  data: JSON.stringify(renderObject)
				 	  success: ->
				 	    return
				 	  type: "POST"
				 	  url: "/upload"
    else
      throw new Error("The XML to JSON converstion returned no JSON data")
    return renderObject
  
  ###
  function handleFileDrop
      this function is called when a file is dropped onto the
      #fileDrop div. It checks that the file is a COLLADA scene
      description file (".dae"), and reads the file.
	@param e -> Captured 'drop' event
	@return null
  ###
  handleFileDrop = (e) ->
	  #Prevent event bubbling
    e.stopPropagation() 
    e.preventDefault()
    if e.dataTransfer.files.length == 1
      file = e.dataTransfer.files[0] #Select the first file
    if file
	    if file.name.substring(file.name.length - 4, file.name.length) is ".dae" #Check it is a ".dae" file
	      reader = new FileReader()
	      #When the file is done reading, call handleFileRead on the result
	      reader.onload = (e) ->
	        handleFileRead(e.target.result)
	        return
	      #Start reading file as text
	      reader.readAsText(file)
	      e.success = true #Tell QUnit that the file was read successfully
	    else
	      throw new Error("File dropped - not COLLADA")
    else
      throw new Error("No file dropped")
    return

  ###
	function handleDragOver
	    this function is called when a file is dragged over the
	    #fileDrop div.
	@param e -> Captured 'dragOver' event
  @return null
  ###
  handleDragOver = (e) ->
    #Prevent event bubbling
    e.stopPropagation()
    e.preventDefault()
    e.dataTransfer.dropEffect = 'copy' #Copy data on drop
    return

  #When the window is ready, add event listeners.
  $(window).ready(->
    fileDrop = $('#fileDrop').get(0)
    if fileDrop
      fileDrop.ondragover = handleDragOver
      fileDrop.ondrop = handleFileDrop
    defineGlobalFunctions()
    return
  )
  
  ###
  function defineGlobalFunctions
      Attach selected functions to the global object, either 'exports'
      for node.js, or 'window' for client scripts.
  ###
  defineGlobalFunctions = ->
    root.globalFunctions = {}
    root.globalFunctions.handleFileRead = handleFileRead
    root.globalFunctions.handleFileDrop = handleFileDrop
    root.globalFunctions.handleDragOver = handleDragOver
    return

else
  alert('The File APIs are not fully supported in this browser.')