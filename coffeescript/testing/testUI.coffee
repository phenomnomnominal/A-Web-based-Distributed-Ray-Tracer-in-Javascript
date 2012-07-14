exampleCollada = window.testCollada

$(document).ready(->
  
  module("File Upload")
	
  test("DragOver event", ->
    $("#qunit-fixture").get(0).ondragover = window.globalFunctions.handleDragOver
    event = $.Event("dragover", 
      dataTransfer:
        dropEffect: null
    )
    $("#qunit-fixture").trigger(event)
    equal(event.dataTransfer.dropEffect, 'copy', "DragOver event should change the dropEffect to 'copy'")
  )
  
  test("Drop event - no file error", ->
    $("#qunit-fixture").get(0).ondrop = window.globalFunctions.handleFileDrop
    event = $.Event("drop", 
      dataTransfer:
        files: []
    )
    raises(-> 
        $("#qunit-fixture").trigger(event)
        return
      , /No file dropped/, "No file dropped")
  )
  
  test("Drop event - incorrect file type", ->
    $("#qunit-fixture").get(0).ondrop = window.globalFunctions.handleFileDrop
    event = $.Event("drop", 
      dataTransfer:
        files: []
    )
    event.dataTransfer.files.push(
      name: "file.file"
    )
    raises(-> 
        $("#qunit-fixture").trigger(event)
        return
      , /File dropped - not COLLADA/, "Incorrect file type dropped")
  )
  
  test("Drop event - correct file type", ->
    $("#qunit-fixture").get(0).ondrop = window.globalFunctions.handleFileDrop
    expect(1)
    event = $.Event("drop", 
      dataTransfer:
        files: []
    )
    event.dataTransfer.files.push(
      name: "file.dae"
    )
    $("#qunit-fixture").trigger(event)
    ok(event.success, "COLLADA file dropped")
  )
  
  test("Read file, empty contents", ->
    expect(1)
    event = "" 
    raises( ->
        window.globalFunctions.handleFileRead(event)
        return
      , /The XML to JSON converstion returned no JSON data/, "No file contents")
  )
  
  test("Read file, COLLADA file", ->
    expect(2)
    renderObject = window.globalFunctions.handleFileRead(exampleCollada)
    notEqual(null, renderObject.url.match(/\:3000\/render\?renderId\=[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/)
    , "renderObject should have a 'urlToShorten' in the form DOMAIN:3000/render?renderId= + UUID")
    notEqual(null, renderObject.sceneDescription
    , "rendorObject should have a sceneDescription object")
  )
  
  return
)