(function() {
  var __hasProp = Object.prototype.hasOwnProperty;

  (function($) {
    var JSONNode, XMLToJSONConverter, functions, util, utilFunctions;
    util = {
      /*
          function isIE
              Check if the client browser is a version 
              of MS Internet Explorer.
          @return true if browser is MSIE else false
      */
      isIE: function() {
        return +"\u0000" === 0;
      },
      /*
          function isString
              Check if an object is a JavaScript String.
          @param o -> object to be tested
          @return true if o is String else false
      */
      isString: function(o) {
        return Object.prototype.toString.call(o) === "[object String]";
      },
      /*
          function isArray
              Check if an object is a JavaScript Array.
          @param o -> object to be tested
          @return true if o is Array else false
      */
      isArray: function(o) {
        return Object.prototype.toString.call(o) === "[object Array]";
      },
      /*
          function isXML
              Check if an object is an XML node.
          @param o -> object to be tested
          @return true if o is XML else false
      */
      isXML: function(o) {
        return typeof o === "object" && this.isDefined(o.nodeName);
      },
      /*
          function isDefined
              Check if an object is currently defined.
          @param o -> object to be tested
          @return true if o is defined else false
      */
      isDefined: function(o) {
        return typeof o !== "undefined";
      },
      /*
          function trim
              Trim excess whitespace from a String.
          @param str -> String to be trimmed
          @return trimmed str
      */
      trim: function(str) {
        var trimmed;
        trimmed = str;
        if (this.isString(str)) {
          trimmed = str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
        }
        return trimmed;
      }
    };
    /*
      class JSONNode
          A JSONNode is an xmlNode converted into a JavaScript 
          object. Each JSONNode contains an array of JSONNodes 
          (its child XML nodes), and their XML attributes. 
      @constuctor xmlNode -> the XML node to be Objectified
    */
    JSONNode = (function() {

      function JSONNode(xmlNode) {
        var attr, _i, _len, _ref;
        this[xmlNode.nodeName] = [];
        _ref = xmlNode.attributes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          attr = _ref[_i];
          this[attr.nodeName] = attr.nodeValue;
        }
      }

      return JSONNode;

    })();
    XMLToJSONConverter = {
      /*
          function compress
              The recursive process that converts the XML element to an
              object creates an array as a placeholder for any children 
              it may have. In the instance where the XML element doesn't
              have any children, an empty array is left over. Typically, 
              when a element doesn't have any children, it does have some
              text content. This gets assigned to the "value" of the 
              JSONNode. We save a bit of space by assigning the value of
              "value" in the place of the empty array.
          @param JSONobject -> JSONNode object to try to compress.
          @return JSONobject -> The original JSONNode with any compression.
      */
      compress: function(JSONobject) {
        var array, key, object, value, _i, _len;
        for (key in JSONobject) {
          if (!__hasProp.call(JSONobject, key)) continue;
          value = JSONobject[key];
          if (util.isArray(value)) {
            array = value;
            if (array.length === 0) {
              JSONobject[key] = void 0;
              if (util.isDefined(JSONobject['value']) && JSONobject['value'] !== "") {
                JSONobject[key] = JSONobject['value'];
                delete JSONobject['value'];
              }
            }
            if (!util.isDefined(JSONobject[key])) {
              JSONobject[key] = true;
            } else {
              for (_i = 0, _len = array.length; _i < _len; _i++) {
                object = array[_i];
                XMLToJSONConverter.compress(object);
              }
            }
          }
        }
        return JSONobject;
      },
      /*
          function build
              The recursive function that converts an XML document to an
              object. Takes an XML element and converts all of its
              children to JSONNode which are attached to the JSONNode
              version of itself. Text and CDATA elements are also attached,
              hover XML comments are ignored. 
          @param parent -> The JSONNode object version of the XML element.
          @param object -> The XML element object.
          @return null
      */
      build: function(parent, object) {
        var cdata, child, newNode, value, _i, _len, _ref;
        if (util.isDefined(parent) && util.isDefined(object)) {
          if (object.hasChildNodes()) {
            _ref = object.childNodes;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              child = _ref[_i];
              switch (child.nodeType) {
                case 1:
                  newNode = new JSONNode(child);
                  if (newNode) {
                    parent[object.nodeName].push(newNode);
                    if (child.hasChildNodes()) {
                      XMLToJSONConverter.build(newNode, child);
                    } else {
                      newNode[child.nodeName] = [];
                    }
                  }
                  break;
                case 3:
                  value = util.trim(child.nodeValue);
                  if (value && value !== "") {
                    if (!parent.value) {
                      parent.value = value;
                    } else {
                      parent.value += value;
                    }
                  }
                  break;
                case 4:
                  cdata = util.isDefined(child.text) ? util.trim(child.text) : util.trim(child.nodeValue);
                  if (!parent.value) {
                    parent.value = cdata;
                  } else {
                    parent.value += cdata;
                  }
              }
            }
          }
        }
      },
      /*
          function stringToXML
              This function takes an XML string and converts it to an 
              cross-browser compatible XML document object.
          @param string -> an XML string to convert into an XML document object.
          @return out -> the converted XML document object.
      */
      stringToXML: function(string) {
        var isParsed, out, xmlDoc;
        xmlDoc = null;
        string = util.trim(string);
        try {
          xmlDoc = util.isIE() ? new ActiveXObject("MSXML2.DOMDocument") : new DOMParser();
          xmlDoc.async = false;
        } catch (error) {
          throw new Error("XML Parser could not be instantiated");
        }
        out = null;
        isParsed = true;
        if (util.isIE()) {
          isParsed = xmlDoc.loadXML(string);
          out = isParsed ? xmlDoc : false;
        } else {
          out = xmlDoc.parseFromString(string, "text/xml");
          isParsed = out.documentElement.tagName !== "parsererror";
        }
        if (!isParsed) throw new Error("Error parsing XML string");
        return out;
      },
      /*
          function go
              Start the XML to Object conversion process. First, we check
              if the object to convert is a String, which we try to convert
              to a XML object. The we create the root object, and call the
              build function on the document, which starts the conversion.
          @param object -> An object to try to convert from XML to JSON
          @return null if the object isn't XML, the nodeValue if the object
              is XML Text or XML CDATA, JSONobject -> the converted object 
              if the conversion is successful
      */
      go: function(object) {
        var JSONobject, xml, xmlRoot;
        if (util.isString(object)) {
          if (object !== "") xml = this.stringToXML(object);
        } else if (util.isXML(object)) {
          xml = object;
        } else {
          xml = null;
        }
        if (!xml) return null;
        xmlRoot = xml.nodeType === 9 ? xml.documentElement : xml.nodeType === 11 ? xml.firstChild : xml;
        if (xml.nodeType === 3 || xml.nodeType === 4) return xml.nodeValue;
        JSONobject = new JSONNode(xmlRoot);
        this.build(JSONobject, xmlRoot);
        return this.compress(JSONobject);
      }
    };
    functions = {
      xmlToJSON: function(xml) {
        return XMLToJSONConverter.go(xml);
      },
      stringToXML: function(str) {
        return XMLToJSONConverter.stringToXML(str);
      }
    };
    utilFunctions = {
      UTILisString: function(o) {
        return util.isString(o);
      },
      UTILisArray: function(o) {
        return util.isArray(o);
      },
      UTILisXML: function(o) {
        return util.isXML(o);
      },
      UTILisDefined: function(o) {
        return util.isDefined(o);
      }
    };
    if (util.isDefined($)) {
      $.extend(functions);
      return $.extend(utilFunctions);
    } else {
      window.XMLToJSON = functions;
      return window.UTIL = utilFunctions;
    }
  })((typeof jQuery !== "undefined") && jQuery || void 0);

}).call(this);
