# *router.coffee* handles all request routing, by either passing requests onto the specific [*requestHandlers*](requestHandlers.html) functions, or creating the generic responses for static files e.g. *.js* and *.css* files.
# ___

# ## Requires:
# Functionality in *router.coffee* requires access to the following [**node.js**](http://nodejs.org/) modules:  

# * [`fs`](http://nodejs.org/api/fs.html) - File System I/O
fs = require 'fs'
# * [`path`](http://nodejs.org/api/path.html) - File path handling and transforming
path = require 'path'
# ___

# ## Routing functions:

# ### <section id='route'>*routeRequest*:</section>
# > **`routeRequest`** takes generic requests and searches for a path specific function in the `handle` object. There are two distinct types of requests:  
#
# > 1. Requests with a specific handler function
#
# > 2. Static file requests
#
# > In the first case, requests are forwarded to and handled by [*requestHandlers*](requestHandlers.html).
#
# > In the second case, we look for a static path to the requested file. If one is found, the static file (e.g. a *'.css'* or *'.js'* file) is returned to the client, otherwise a **404** error is sent.
# 
# > Care is taken to ensure that the correct [**ContentType**](http://en.wikipedia.org/wiki/List_of_HTTP_header_fields) header is set in the response.
routeRequest = (handle, pathname, response, sessionID, postData) ->
  extension = path.extname pathname
  switch extension
    when '.js' then contentType = 'text/javascript'
    when '.css' then contentType = 'text/css'
    else contentType = 'text/plain'
  if typeof handle[pathname] is 'function'
    if postData?
      handle[pathname] response, postData, sessionID
    else 
      handle[pathname] response
  else if contentType
    path.exists ".#{pathname}", (exists) ->
      if exists
        fs.readFile ".#{pathname}", (error, content) ->
          if error?
            response.writeHead 500
          else
            response.writeHead 200, 'Content-Type': contentType
      else
        response.writeHead 404, 'Content-Type': contentType
  else
    response.writeHead 404, 'Content-Type': contentType

# ___
# ## Exports:

# The [**`routeRequest`**](#route) function is added to the global `root` object.
root = exports ? this
root.route = routeRequest