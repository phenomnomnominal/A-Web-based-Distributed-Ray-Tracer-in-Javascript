querystring = require("querystring")
database = require("../database")
urlShorten = require("../urlShorten")

exports.master = (sessionID, response) ->
  response.render( "master", 
      title: "Master"  
    )
  return

exports.test = (sessionID, response) ->
	response.render( "test",
	    layout: false
	  )
	return
	
exports.render = (sessionID, response) ->
  console.log "Request to handler 'render' was called."
  response.render( "index",
      title: "Slave"
  )
  return
  
exports.getRender = (sessionID, response, getRender) ->
  console.log "Request to handler 'getRender' was called."
  database.find(getRender.renderId, sessionID)
  return

exports.upload = (sessionID, response, renderObject) ->
  console.log "Request to handler 'upload' was called."
  urlShorten.shortenURL(renderObject.url, sessionID)
  database.insert(renderObject)
  return