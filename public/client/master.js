(function() {
  var defineGlobalFunctions, handleDragOver, handleFileDrop, handleFileRead, socket;

  if (window.File && window.FileReader && window.FileList && window.Blob) {
    socket = io.connect("http://127.0.0.1", {
      "connect timeout": 500,
      "reconnect": true,
      "reconnection delay": 500,
      "reopen delay": 600,
      "max reconnection attempts": 10
    });
    socket.on("connected", function(data) {
      socket.emit("confirmConnection", {
        connection: "confirmed"
      });
      socket.on("urlShortened", function(data) {
        $("#infoReport").text(data.shortURL);
      });
    });
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
        WEBSITE = "http://127.0.0.1:3000/render?renderId=";
        renderObject = {
          url: WEBSITE + uuid,
          uuid: uuid,
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
      this.globalFunctions = {};
      this.globalFunctions.handleFileRead = handleFileRead;
      this.globalFunctions.handleFileDrop = handleFileDrop;
      this.globalFunctions.handleDragOver = handleDragOver;
    };
  } else {
    alert('The File APIs are not fully supported in this browser.');
  }

}).call(this);
