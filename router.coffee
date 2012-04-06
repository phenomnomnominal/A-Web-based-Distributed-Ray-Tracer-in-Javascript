fs = require("fs")
path = require("path")

route = (handle, pathname, response, postData) ->
  console.log pathname
  console.log "About to route a request for #{pathname}"
  extension = path.extname(pathname)
  switch extension
    when ".js" then contentType = "text/javascript"
    when ".css" then contentType = "text/css"
  if typeof handle[pathname] is 'function'
    handle[pathname](response, postData)
  else if contentType
    path.exists("." + pathname, (exists) ->
      if exists
        fs.readFile("." + pathname, (error, content) ->
          if (error)
            response.writeHead(500)
            response.end()
          else
            response.writeHead(200, 
              "Content-Type": contentType
            )
            response.end(content, "utf-8")
        )
      else
        response.writeHead( 404, 
          "Content-Type": "text/plain"
        )
        response.write "404 Not found"
        response.end()
    )
  else
    console.log("No request handler found for #{pathname}")
    response.writeHead( 404, 
      "Content-Type": "text/plain"
    )
    response.write "404 Not found"
    response.end()
  return

exports.route = route