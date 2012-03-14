### 
GET home page. 
###

exports.index = (request, response) ->
  response.render "index",
    title: "Express"
  return