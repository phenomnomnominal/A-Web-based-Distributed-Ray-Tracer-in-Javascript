(($) ->
  # Utility function object
  util =
    ###
    function isIE
        Check if the client browser is a version 
        of MS Internet Explorer.
    @return true if browser is MSIE else false
    ###
    isIE: ->
      +"\u0000" is 0
    ###
    function isString
        Check if an object is a JavaScript String.
    @param o -> object to be tested
    @return true if o is String else false
    ###
    isString: (o) ->
      Object::toString.call(o) is "[object String]"
    ###
    function isArray
        Check if an object is a JavaScript Array.
    @param o -> object to be tested
    @return true if o is Array else false
    ###
    isArray: (o) ->
      Object::toString.call(o) is "[object Array]"
    ###
    function isXML
        Check if an object is an XML node.
    @param o -> object to be tested
    @return true if o is XML else false
    ###
    isXML: (o) ->
      typeof(o) is "object" && this.isDefined(o.nodeName)
    ###
    function isDefined
        Check if an object is currently defined.
    @param o -> object to be tested
    @return true if o is defined else false
    ###
    isDefined: (o) ->
      typeof(o) isnt "undefined"
    ###
    function trim
        Trim excess whitespace from a String.
    @param str -> String to be trimmed
    @return trimmed str
    ###
    trim: (str) ->
      trimmed = str
      if this.isString(str) then trimmed = str.replace(/^\s\s*/, '').replace(/\s\s*$/, '')
      return trimmed
  
  
  ###
  class JSONNode
      A JSONNode is an xmlNode converted into a JavaScript 
      object. Each JSONNode contains an array of JSONNodes 
      (its child XML nodes), and their XML attributes. 
  @constuctor xmlNode -> the XML node to be Objectified
  ###
  class JSONNode
    constructor: (xmlNode) ->
      this[xmlNode.nodeName] = []
      for attr in xmlNode.attributes
        this[attr.nodeName] = attr.nodeValue
  

  #Main object, contains all conversion functions
  XMLToJSONConverter =
    ###
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
    ###
    compress: ( JSONobject ) ->
      for own key, value of JSONobject
        if util.isArray(value)
          array = value
          if array.length is 0 
            JSONobject[key] = undefined
            if util.isDefined(JSONobject['value']) and JSONobject['value'] isnt ""
              JSONobject[key] = JSONobject['value']
              delete JSONobject['value']
          if not util.isDefined(JSONobject[key])
            JSONobject[key] = true
          else
            #If the JSONobject has children, attempt to compress them.
            for object in array
              XMLToJSONConverter.compress(object)
      return JSONobject
    ###
    function build
        The recursive function that converts an XML document to an
        object. Takes an XML element and converts all of its
        children to JSONNode which are attached to the JSONNode
        version of itself. Text and CDATA elements are also attached,
        hover XML comments are ignored. 
    @param parent -> The JSONNode object version of the XML element.
    @param object -> The XML element object.
    @return null
    ###
    build: ( parent, object) ->
      if util.isDefined(parent) and util.isDefined(object)
        if object.hasChildNodes()
          for child in object.childNodes
            switch child.nodeType
              when 1 #Child node is a XML element
                newNode = new JSONNode(child)
                if newNode
                  parent[object.nodeName].push(newNode)
                  if child.hasChildNodes()
                    XMLToJSONConverter.build(newNode, child)
                  else
                    newNode[child.nodeName] = []
              when 3 #Child node is a text element
                value = util.trim(child.nodeValue)
                if value && value isnt ""
                  if not parent.value
                    parent.value = value
                  else
                    parent.value += value
              when 4 #Child node is a CDATA element
                cdata = if util.isDefined(child.text) then util.trim(child.text) else util.trim(child.nodeValue)
                if not parent.value
                    parent.value = cdata
                  else
                    parent.value += cdata
      return
    ###
    function stringToXML
        This function takes an XML string and converts it to an 
        cross-browser compatible XML document object.
    @param string -> an XML string to convert into an XML document object.
    @return out -> the converted XML document object.
    ###
    stringToXML: (string) ->
      xmlDoc = null
      string = util.trim(string)
      try
        xmlDoc = if util.isIE() then new ActiveXObject("MSXML2.DOMDocument") else new DOMParser()
        xmlDoc.async = false
      catch error
        throw new Error("XML Parser could not be instantiated")
      out = null
      isParsed = true
      if util.isIE()
        isParsed = xmlDoc.loadXML(string)
        out = if isParsed then xmlDoc else false
      else
        out = xmlDoc.parseFromString(string, "text/xml")
        isParsed = (out.documentElement.tagName isnt "parsererror")
      if not isParsed
        throw new Error("Error parsing XML string")
      return out
    ###
    function go
        Start the XML to Object conversion process. First, we check
        if the object to convert is a String, which we try to convert
        to a XML object. The we create the root object, and call the
        build function on the document, which starts the conversion.
    @param object -> An object to try to convert from XML to JSON
    @return null if the object isn't XML, the nodeValue if the object
        is XML Text or XML CDATA, JSONobject -> the converted object 
        if the conversion is successful 
    ###
    go: (object) ->
      if util.isString(object)
        if object isnt ""
          xml = this.stringToXML(object)
      else if util.isXML(object)
        xml = object
      else
        xml = null
      if not xml then return null
      xmlRoot = if xml.nodeType is 9 then xml.documentElement else if xml.nodeType is 11 then xml.firstChild else xml
      if xml.nodeType is 3 or xml.nodeType is 4 then return xml.nodeValue
      JSONobject = new JSONNode(xmlRoot)
      this.build(JSONobject, xmlRoot)
      this.compress(JSONobject)

  functions = 
    xmlToJSON: (xml) ->
      XMLToJSONConverter.go(xml)
    stringToXML: (str) ->
      XMLToJSONConverter.stringToXML(str)
      
  utilFunctions =
    UTILisString: (o) ->
      util.isString(o)
    UTILisArray: (o) ->
      util.isArray(o)
    UTILisXML: (o) ->
      util.isXML(o)
    UTILisDefined: (o) ->
      util.isDefined(o)

  #Add the conversion function to the jQuery object, or
  #to window if jQuery isn't defined.
  if util.isDefined($)
    $.extend(functions)
    $.extend(utilFunctions)
    
  else
    window.XMLToJSON = functions
    window.UTIL = utilFunctions
          
)((typeof(jQuery) isnt "undefined") and jQuery or undefined)