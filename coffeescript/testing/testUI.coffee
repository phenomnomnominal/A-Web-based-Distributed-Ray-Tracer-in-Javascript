exampleCollada = window.testCollada
resultingJSON = window.testJSON

$(document).ready ->
  
  module 'User Interface - Master - File Upload'
	
  test 'Test that "handleDragOver" work correctly on a "dragover" event', ->
    expect 3
    event = $.Event 'dragover', dataTransfer: dropEffect: null
    ok event?, 'If we create a mock "dragover" event object with the
                "dataTransfor.dropEffect" property set to null'
    ok window.master.handleDragOver?,
      'and trigger the "dragover" event with the event object,'
    $('#qunit-fixture').get(0).ondragover = window.master.handleDragOver
    $('#qunit-fixture').trigger event
    equal event.dataTransfer.dropEffect, 'copy',
      'the "dropEffect" property of the event object should change to "copy".'
  
  test 'Test that "handleFileDrop" works correctly on a "drop" event when
        no file is dropped.', ->
    expect 3
    event = $.Event "drop", dataTransfer: files: []
    ok event?, 'If we create a mock "drop" event object with the
                "dataTransfor.files" property set to an empty Array'
    ok window.master.handleFileDrop?,
      'and trigger the "drop" event with the event object,'
    $('#qunit-fixture').get(0).ondrop = window.master.handleFileDrop
    raises (-> $('#qunit-fixture').trigger event)
      , /UI Error: No file dropped./,
      'an Error is thrown: "UI Error: No file dropped."'
  
  test 'Test that "handleFileDrop" works correctly on a "drop" event when
        an incorrect file type is dropped', ->
    expect 3
    event = $.Event 'drop', dataTransfer: files: [name: 'file.file']
    ok event?, 'If we create a mock "drop" event object with the
                "dataTransfor.files" property set to an Array
                with a mock file object of the wrong file type'
    ok window.master.handleFileDrop?,
      'and trigger the "drop" event  with the event object,'
    $('#qunit-fixture').get(0).ondrop = window.master.handleFileDrop
    raises (-> $('#qunit-fixture').trigger event)
      , /UI Error: The file dropped is not a COLLADA file./,
      'an Error is thrown: "UI Error: The file dropped is not a COLLADA file."'
  
  test 'Test that "handleFileDrop" works correctly on a "drop" event when
        a correct file type is dropped', ->
    expect 3
    event = $.Event 'drop', dataTransfer: files: [name: 'file.dae']
    ok event?, 'If we create a mock "drop" event object with the
                "dataTransfor.files" property set to an Array
                with a mock file object of the correct file type'
    ok window.master.handleFileDrop?,
      'and trigger the "drop" event with the event object,'
    $("#qunit-fixture").get(0).ondrop = window.master.handleFileDrop
    $("#qunit-fixture").trigger event
    ok event.success, 'the "success" property of the even should be "true",
                       indicating that a COLLADA file was dropped.'
  
  test 'Test that "handleFileRead" works correctly on an empty file', ->
    expect 3
    event = ""
    ok event?, 'If we create an empty JSON string - i.e. an empty String "" -'
    ok window.master.handleFileRead?,
      'and pass it to the handleFileRead function'
    raises (-> window.master.handleFileRead event)
      , /UI Error: The XML to JSON conversion returned no JSON data./,
      'an Error is thrown: "UI Error: The XML to JSON conversion
       returned no JSON data."'
  
  test 'Test that "handleFileRead" works correctly on a COLLADA file', ->
    expect 8
    ok exampleCollada?, 'If we take the "exampleCollada" XML document'
    ok window.master.handleFileRead?,
      'and pass it to the handleFileRead function'
    renderObject = window.master.handleFileRead exampleCollada
    ok renderObject?, 'an object should be returned'
    UUIDregex = ///
                   \:3000/render\?renderId\=
                   [a-f0-9]{8}-
                   [a-f0-9]{4}-
                   [a-f0-9]{4}-
                   [a-f0-9]{4}-
                   [a-f0-9]{12}
                ///
    ok renderObject.url?, 'which as a "url" property'
    ok renderObject.url.match(UUIDregex),
      'of the form DOMAIN:3000/render?renderId= + UUID.'
    ok renderObject.sceneDescription?,
      'It should also have a sceneDescription object'
    ok _.isString(renderObject.sceneDescription), 'which is a JSON string'
    equal renderObject.sceneDescription, resultingJSON,
      'that matches resultingJSON.'