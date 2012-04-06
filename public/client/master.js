(function() {
  var defineGlobalFunctions, handleDragOver, handleFileDrop, handleFileRead, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  if (window.File && window.FileReader && window.FileList && window.Blob) {
    /*
      function handleFileRead
          This function takes any XML content from the uploaded file,
          converts it to a JSON string and POSTs it to the server.
      @param readerOutput -> Output from the file reading output
      @return null
    */
    handleFileRead = function(readerOutput) {
      var WEBSITE, json, renderObject, uuid;
      json = $.xmlToJSON(readerOutput);
      if (json !== void 0 && json !== null) {
        uuid = UUID.genV1().toString();
        WEBSITE = "localhost:3000?render=";
        renderObject = {
          urlToShorten: WEBSITE + uuid,
          sceneDescription: JSON.stringify(json)
        };
        $.ajax({
          contentType: "application/json",
          data: JSON.stringify(renderObject),
          success: function() {},
          type: "POST",
          url: "/upload"
        });
      } else {
        throw new Error("The XML to JSON converstion returned no JSON data");
      }
      return renderObject;
    };
    /*
      function handleFileDrop
          this function is called when a file is dropped onto the
          #fileDrop div. It checks that the file is a COLLADA scene
          description file (".dae"), and reads the file.
    	@param e -> Captured 'drop' event
    	@return null
    */
    handleFileDrop = function(e) {
      var file, reader;
      e.stopPropagation();
      e.preventDefault();
      if (e.dataTransfer.files.length === 1) file = e.dataTransfer.files[0];
      if (file) {
        if (file.name.substring(file.name.length - 4, file.name.length) === ".dae") {
          reader = new FileReader();
          reader.onload = function(e) {
            handleFileRead(e.target.result);
          };
          reader.readAsText(file);
          e.success = true;
        } else {
          throw new Error("File dropped - not COLLADA");
        }
      } else {
        throw new Error("No file dropped");
      }
    };
    /*
    	function handleDragOver
    	    this function is called when a file is dragged over the
    	    #fileDrop div.
    	@param e -> Captured 'dragOver' event
      @return null
    */
    handleDragOver = function(e) {
      e.stopPropagation();
      e.preventDefault();
      e.dataTransfer.dropEffect = 'copy';
    };
    $(window).ready(function() {
      var fileDrop;
      fileDrop = $('#fileDrop').get(0);
      if (fileDrop) {
        fileDrop.ondragover = handleDragOver;
        fileDrop.ondrop = handleFileDrop;
      }
      defineGlobalFunctions();
    });
    /*
      function defineGlobalFunctions
          Attach selected functions to the global object, either 'exports'
          for node.js, or 'window' for client scripts.
    */
    defineGlobalFunctions = function() {
      root.globalFunctions = {};
      root.globalFunctions.handleFileRead = handleFileRead;
      root.globalFunctions.handleFileDrop = handleFileDrop;
      root.globalFunctions.handleDragOver = handleDragOver;
    };
  } else {
    alert('The File APIs are not fully supported in this browser.');
  }

}).call(this);
