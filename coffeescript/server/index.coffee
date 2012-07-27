# *index.coffee* is the entry point into the server code. The compiled version (*index.js*) is run by calling   
#
#     node javascript/server/index.js
#
# from the command line. This initialises the server for accepting requests from clients.
# ___

# ## Requires:
# Functionality in *index.coffee* requires access to the following packages:

# > * [`server`](server.html) - Server initialisation and configuration, as well as core server functionality
server = require './server'
# > * [`router`](router.html) - Generic routing functionality
router = require './router'
# > * [`requestHandlers`](requestHandlers.html) - Handler functions for specific server requests
requestHandlers = require './requestHandlers'
#___

# ## Path-specific request handlers:

# Specific routing functions from `requestHandlers` are associated with their respective paths in the `handlers` object.
handlers = 
  # * *'/'* and *'/master'* are both assosciated with the [**`master`**](requestHandlers.html#master) function. The **`master`** function generates the render upload page, which allows the user to upload and initialise a rendering operation.
  
  '/': requestHandlers.master
  '/master': requestHandlers.master
  
  # * When the user uploads a [**COLLADA**](http://www.collada.org) file, the data is posted the [**`upload`**](requestHandlers.html#upload) function. The file is first parsed by [*sceneHandler.coffee*](sceneHandler.html), then the resulting render object is inserted into the database by [*database.coffee*](database.html) and finally a shortened URL (using the format from the [**Google URL Shortener**](http://goo.gl/)) is generated by [*urlShorten.coffee*](urlShorten.html) which is returned to the user. The shortened URLs generated by **`upload`** use the [**UUID Version 4**](http://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29) to identify each render:
  
  '/upload': requestHandlers.upload
  # >     render?renderId=XXXXXXXX-XXXX-4XXX-YXXX-XXXXXXXXXXXX
  
  # * Paths that start with *'/render'* are assosciated with the [**`render`**](requestHandlers.html#render) function. The **`render`** function generates the rendering page, which first posts the `renderID` from the URL to *'/getRender'*, which returns the appropriate render object from the database.
  
  '/render': requestHandlers.render
  
  # * When a user requests a shortened URL provided by the **`upload`** function, the corresponding `renderID` is posted to the [**`getRender`**](requestHandlers.html#get-render) function. This retrieves the render object from the database and sends it back to the user via a [**WebSocket**](http://www.websocket.org/).
  
  '/getRender': requestHandlers.getRender

  # * The **`test`** function initialises and perform all of the [**QUnit**](http://docs.jquery.com/QUnit) regression and unit tests.
  
  '/test': requestHandlers.test

# ___

# ## Initialisation:
  
# To start the server, [**`router.route`**](router.html#route), the generic routing function from router that handles file requests (such as *.css* and *.js* files), and the `handlers` object is passed to the [**`server.init`**](server.html#init) function.
server.init router.route, handlers