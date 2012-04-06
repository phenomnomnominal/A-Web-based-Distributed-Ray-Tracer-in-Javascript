### 
Module dependencies 
###
express = require("express")
url = require("url")

init = (route, handle) ->
  onRequest = (request, response) ->
    postData = ""
    pathname = url.parse(request.url).pathname
    request.setEncoding "utf8"
    
    request.addListener("data", (postDataChunk) ->
      postData += postDataChunk
      console.log "Received POST data chunk '#{ postDataChunk }'."
      return
    )
    
    request.addListener("end", ->
      route(handle, pathname, response, postData)
      return
    )
    return

  server = module.exports = express.createServer(onRequest).listen(3000)

  ### 
  Server Configuration 
  ###
  server.configure ->
    server.set "views", "#{ __dirname }/views"
    server.set "view engine", "jade"
    server.use express.logger()
    server.use express.bodyParser()
    server.use express.cookieParser()
    server.use express.session(
      secret: "phenomnomnominal"
      id: new Date()
    )
    server.use express.methodOverride()
    server.use server.router
    server.use express.static("#{ __dirname }/public")
    return

  server.configure ->
    server.use express.errorHandler(
      dumpExceptions: true
      showStack: true
    )
    return

  server.configure ->
    server.use express.errorHandler()
    return

  console.log "Express server listening on port #{ server.address().port } in #{ server.settings.env } mode"   
  
  return

exports.init = init