(function() {
  var JSONString, exampleCollada, xmlDoc, xmlString;

  xmlString = "<?xml version='1.0'?><testxml><textAndAttr attribute='attr'>Text</textAndAttr><attrOnly attribute='1'></attrOnly><textOnly>Text</textOnly><selfClosingNode attribute='attr'/><parent><childMultiAttr attribute1='attr1' attribute2='attr2'>Item 1</childMultiAttr><childTextAndAttr attribute='1'>Item 2</childTextAndAttr><childTextOnly>Item 3</childTextOnly><childAttrOnly attribute='attribute'></childAttrOnly><childWithChild><node>Hello</node><node>Hello</node><node>Hello</node></childWithChild><![CDATA[function matchwo(a,b) { if (a < b && a < 0) then { return 1;} else {return 0;}}]]><!-- Comment which will be ignored --></parent></testxml>";

  xmlDoc = $.stringToXML(xmlString);

  JSONString = '{"testxml":[{"textAndAttr":"Text","attribute":"attr"},{"attrOnly":true,"attribute":"1"},{"textOnly":"Text"},{"selfClosingNode":true,"attribute":"attr"},{"parent":[{"childMultiAttr":"Item 1","attribute1":"attr1","attribute2":"attr2"},{"childTextAndAttr":"Item 2","attribute":"1"},{"childTextOnly":"Item 3"},{"childAttrOnly":true,"attribute":"attribute"},{"childWithChild":[{"node":"Hello"},{"node":"Hello"},{"node":"Hello"}]}],"value":"function matchwo(a,b) { if (a < b && a < 0) then { return 1;} else {return 0;}}"}]}';

  exampleCollada = window.testCollada;

  $(document).ready(function() {
    module("xmlToJSON");
    test("XML String to JSON", function() {
      var JSONFromString;
      JSONFromString = JSON.stringify($.xmlToJSON(xmlString));
      return equal(JSONFromString, JSONString, "JSONString is expected to be equal to JSONFromString");
    });
    test("XML Doc to JSON", function() {
      var JSONFromDoc;
      JSONFromDoc = JSON.stringify($.xmlToJSON(xmlDoc));
      return equal(JSONFromDoc, JSONString, "JSONString is expected to be equal to JSONFromDoc");
    });
    test("XML Doc to JSON vs. XML String to JSON", function() {
      var JSONFromDoc, JSONFromString;
      JSONFromDoc = $.xmlToJSON(xmlDoc);
      JSONFromString = $.xmlToJSON(xmlString);
      return deepEqual(JSONFromDoc, JSONFromString, "JSONFromDoc is expected to be equal to JSONFromString");
    });
    test("Try to convert a non-XML object", function() {
      var nonXML;
      nonXML = 9;
      return equal(null, $.xmlToJSON(nonXML), "Non-XML input should return null");
    });
    test("CDATA to JSON", function() {
      var CDATA, CDATAString, JSONFromCDATA, functionString;
      functionString = "function matchwo(a,b) { if (a < b && a < 0) then { return 1;} else {return 0;}}";
      CDATAString = "<?xml version='1.0'?><cdata><![CDATA[" + functionString + "]]></cdata>";
      CDATA = $.stringToXML(CDATAString).firstChild.firstChild;
      JSONFromCDATA = $.xmlToJSON(CDATA);
      return equal(functionString, JSONFromCDATA, "XML CDATA input should return nodeValue");
    });
    test("TEXT to JSON", function() {
      var JSONFromTEXT, TEXT, textString, xmlTextString;
      textString = "A LONG LINE OF TEXT";
      xmlTextString = "<?xml version='1.0'?><text>" + textString + "</text>";
      TEXT = $.stringToXML(xmlTextString).firstChild.firstChild;
      JSONFromTEXT = $.xmlToJSON(TEXT);
      return equal(textString, JSONFromTEXT, "XML TEXT input should return nodeValue");
    });
    module("UTIL");
    test("UTILisString", function() {
      expect(5);
      ok($.UTILisString("STRING"));
      equal(false, $.UTILisString(1));
      equal(false, $.UTILisString([]));
      equal(false, $.UTILisString({}));
      return equal(false, $.UTILisString(xmlDoc));
    });
    test("UTILisArray", function() {
      expect(5);
      ok($.UTILisArray([]));
      equal(false, $.UTILisArray(1));
      equal(false, $.UTILisArray("STRING"));
      equal(false, $.UTILisArray({}));
      return equal(false, $.UTILisArray(xmlDoc));
    });
    test("UTILisXML", function() {
      expect(5);
      ok($.UTILisXML(xmlDoc));
      equal(false, $.UTILisXML(1));
      equal(false, $.UTILisXML("STRING"));
      equal(false, $.UTILisXML({}));
      return equal(false, $.UTILisXML([]));
    });
    test("UTILisDefined", function() {
      expect(2);
      ok($.UTILisDefined(1));
      return equal(false, $.UTILisDefined(void 0));
    });
    module("File Upload");
    test("DragOver event", function() {
      var event;
      $("#qunit-fixture").get(0).ondragover = window.globalFunctions.handleDragOver;
      event = $.Event("dragover", {
        dataTransfer: {
          dropEffect: null
        }
      });
      $("#qunit-fixture").trigger(event);
      return equal(event.dataTransfer.dropEffect, 'copy', "DragOver event should change the dropEffect to 'copy'");
    });
    test("Drop event - no file error", function() {
      var event;
      $("#qunit-fixture").get(0).ondrop = window.globalFunctions.handleFileDrop;
      event = $.Event("drop", {
        dataTransfer: {
          files: []
        }
      });
      return raises(function() {
        $("#qunit-fixture").trigger(event);
      }, /No file dropped/, "No file dropped");
    });
    test("Drop event - incorrect file type", function() {
      var event;
      $("#qunit-fixture").get(0).ondrop = window.globalFunctions.handleFileDrop;
      event = $.Event("drop", {
        dataTransfer: {
          files: []
        }
      });
      event.dataTransfer.files.push({
        name: "file.file"
      });
      return raises(function() {
        $("#qunit-fixture").trigger(event);
      }, /File dropped - not COLLADA/, "Incorrect file type dropped");
    });
    test("Drop event - correct file type", function() {
      var event;
      $("#qunit-fixture").get(0).ondrop = window.globalFunctions.handleFileDrop;
      expect(1);
      event = $.Event("drop", {
        dataTransfer: {
          files: []
        }
      });
      event.dataTransfer.files.push({
        name: "file.dae"
      });
      $("#qunit-fixture").trigger(event);
      return ok(event.success, "COLLADA file dropped");
    });
    test("Read file, empty contents", function() {
      var event;
      expect(1);
      event = "";
      return raises(function() {
        window.globalFunctions.handleFileRead(event);
      }, /The XML to JSON converstion returned no JSON data/, "No file contents");
    });
    test("Read file, COLLADA file", function() {
      var renderObject;
      expect(2);
      renderObject = window.globalFunctions.handleFileRead(exampleCollada);
      notEqual(null, renderObject.urlToShorten.match(/^localhost\:3000\?render\=[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/), "renderObject should have a 'urlToShorten' in the form localhost:3000?render= + UUID");
      return notEqual(null, renderObject.sceneDescription, "rendorObject should have a sceneDescription object");
    });
  });

}).call(this);
