querystring = require("querystring")

exports.master = (response) ->
  console.log "Request to handler 'master' was called."
  response.render( "index",
      title: "Master"
    )
  response.end()
  return

exports.slave = (response)->
  console.log "Request to handler 'slave' was called."
  response.render( "index",
      title: "Slave"
    )
  response.end()
  return

exports.test = (response)->
	console.log "Request to handle 'test' was called."
	response.render( "test",
	    title: "Testing"
	    layout: false
	  )
	response.end()
	return

exports.upload = (response, postData)->
  console.log "Request to handler 'upload' was called."
  response.render( "index",
      title: "Upload"
      postData: querystring.parse(postData).text
    )
  response.end()
  return