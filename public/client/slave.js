(function() {

  $(window).ready(function() {
    var socket;
    socket = io.connect("http://127.0.0.1", {
      "connect timeout": 500,
      "reconnect": true,
      "reconnection delay": 500,
      "reopen delay": 600,
      "max reconnection attempts": 10
    });
    socket.on("connected", function(data) {
      var getRenderObj;
      socket.emit("confirmConnection", {
        connection: "confirmed"
      });
      socket.on("gotRender", function(data) {
        $("#infoReport").text(data.render.sceneDescription);
      });
      getRenderObj = {
        renderId: window.location.href.substring(window.location.href.length - 36)
      };
      $.ajax({
        contentType: "application/json",
        data: JSON.stringify(getRenderObj),
        type: "POST",
        url: "/getRender"
      });
    });
  });

}).call(this);
