fs = require("fs")
path = require("path")

route = (handle, sessionID, pathname, response, postData) ->
  extension = path.extname(pathname)
  switch extension
    when ".js" then contentType = "text/javascript"
    when ".css" then contentType = "text/css"
  if typeof handle[pathname] is 'function'
    handle[pathname](sessionID, response, postData)
  else if contentType
    path.exists("." + pathname, (exists) ->
      if exists
        fs.readFile("." + pathname, (error, content) ->
          if (error)
            response.writeHead(500)
          else
            response.writeHead(200, 
              "Content-Type": contentType
            )
          return
        )
      else
        response.writeHead( 404, 
          "Content-Type": "text/plain"
        )
        response.write "404 Not found"
      return
    )
  else
    response.writeHead( 404, 
      "Content-Type": "text/plain"
    )
    response.write "404 Not found"
  return

exports.route = route