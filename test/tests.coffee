xmlString = "<?xml version='1.0'?><testxml><textAndAttr attribute='attr'>Text</textAndAttr><attrOnly attribute='1'></attrOnly><textOnly>Text</textOnly><selfClosingNode attribute='attr'/><parent><childMultiAttr attribute1='attr1' attribute2='attr2'>Item 1</childMultiAttr><childTextAndAttr attribute='1'>Item 2</childTextAndAttr><childTextOnly>Item 3</childTextOnly><childAttrOnly attribute='attribute'></childAttrOnly><childWithChild><node>Hello</node><node>Hello</node><node>Hello</node></childWithChild><![CDATA[function matchwo(a,b) { if (a < b && a < 0) then { return 1;} else {return 0;}}]]><!-- Comment which will be ignored --></parent></testxml>"
xmlDoc = $.stringToXML(xmlString)
JSONString = '{"testxml":[{"textAndAttr":"Text","attribute":"attr"},{"attrOnly":true,"attribute":"1"},{"textOnly":"Text"},{"selfClosingNode":true,"attribute":"attr"},{"parent":[{"childMultiAttr":"Item 1","attribute1":"attr1","attribute2":"attr2"},{"childTextAndAttr":"Item 2","attribute":"1"},{"childTextOnly":"Item 3"},{"childAttrOnly":true,"attribute":"attribute"},{"childWithChild":[{"node":"Hello"},{"node":"Hello"},{"node":"Hello"}]}],"value":"function matchwo(a,b) { if (a < b && a < 0) then { return 1;} else {return 0;}}"}]}'
exampleCollada = window.testCollada

$(document).ready(->
  
  module("xmlToJSON")
  
  test("XML String to JSON", ->
    JSONFromString = JSON.stringify($.xmlToJSON(xmlString))
    equal(JSONFromString, JSONString, "JSONString is expected to be equal to JSONFromString")
  )
  
  test("XML Doc to JSON", ->
    JSONFromDoc = JSON.stringify($.xmlToJSON(xmlDoc))
    equal(JSONFromDoc, JSONString, "JSONString is expected to be equal to JSONFromDoc")
  )
  
  test("XML Doc to JSON vs. XML String to JSON", ->
    JSONFromDoc = $.xmlToJSON(xmlDoc)
    JSONFromString = $.xmlToJSON(xmlString)
    deepEqual(JSONFromDoc, JSONFromString, "JSONFromDoc is expected to be equal to JSONFromString")
  )
  
  test("Try to convert a non-XML object", ->
    nonXML = 9
    equal(null, $.xmlToJSON(nonXML), "Non-XML input should return null")  
  )
  
  test("CDATA to JSON", ->
    functionString = "function matchwo(a,b) { if (a < b && a < 0) then { return 1;} else {return 0;}}"
    CDATAString = "<?xml version='1.0'?><cdata><![CDATA[#{functionString}]]></cdata>" 
    CDATA = $.stringToXML(CDATAString).firstChild.firstChild
    JSONFromCDATA = $.xmlToJSON(CDATA)
    equal(functionString, JSONFromCDATA, "XML CDATA input should return nodeValue")
  )
  
  test("TEXT to JSON", ->
    textString = "A LONG LINE OF TEXT"
    xmlTextString = "<?xml version='1.0'?><text>#{textString}</text>" 
    TEXT = $.stringToXML(xmlTextString).firstChild.firstChild
    JSONFromTEXT = $.xmlToJSON(TEXT)
    equal(textString, JSONFromTEXT, "XML TEXT input should return nodeValue")
  )
  
  module("UTIL")
  
  test("UTILisString", ->
    expect(5)
    ok($.UTILisString("STRING"))
    equal(false, $.UTILisString(1))
    equal(false, $.UTILisString([]))
    equal(false, $.UTILisString({}))
    equal(false, $.UTILisString(xmlDoc))
  )
  
  test("UTILisArray", ->
    expect(5)
    ok($.UTILisArray([]))
    equal(false, $.UTILisArray(1))
    equal(false, $.UTILisArray("STRING"))
    equal(false, $.UTILisArray({}))
    equal(false, $.UTILisArray(xmlDoc))
  )
  
  test("UTILisXML", ->
    expect(5)
    ok($.UTILisXML(xmlDoc))
    equal(false, $.UTILisXML(1))
    equal(false, $.UTILisXML("STRING"))
    equal(false, $.UTILisXML({}))
    equal(false, $.UTILisXML([]))
  )
  
  test("UTILisDefined", ->
    expect(2)
    ok($.UTILisDefined(1))
    equal(false, $.UTILisDefined(undefined))
  )

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
    notEqual(null, renderObject.urlToShorten.match(/^localhost\:3000\?render\=[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/)
    , "renderObject should have a 'urlToShorten' in the form localhost:3000?render= + UUID")
    notEqual(null, renderObject.sceneDescription
    , "rendorObject should have a sceneDescription object")
  )
  
  return
)