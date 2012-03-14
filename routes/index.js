
/* 
GET home page.
*/

(function() {

  exports.index = function(request, response) {
    response.render("index", {
      title: "Express"
    });
  };

}).call(this);
