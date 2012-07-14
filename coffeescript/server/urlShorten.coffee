# *urlShorten.coffee* uses the [**Google URL Shortener**](http://goo.gl/) API to generate shortened URLs that contain the unique id of a specific render. The shortened URLs generated are of the following form:
#
#  >     render?renderId=12345678-9101-1121-3141-516171819202
# ___

# ## Requires:
# Functionality in *database.coffee* requires access to the following [node.js](http://nodejs.org/) modules:

# * [Google URL Shortener](http://goo.gl/) - node.js implementation of the Google URL Shortener API
googl = require 'goo.gl'
# ___

# ## Constants:
# Some constants are required for this script:

# > * **`GOOGLE_API_KEY`** - *Access key to the Google APIs.*
GOOGLE_API_KEY = 'AIzaSyBxnkRXgec4V_oOnx5zqJKDVpQI-x_G4R0'

#___

# ## Initialisation:
# When [*index.coffee*](index.html) runs and the [**node.js**](http://nodejs.org/) server is initialised, this script is run, which sets the correct API key in the **`googl`** package.
googl.setKey GOOGLE_API_KEY

# ___

# ## Functions:

# ### <section id='shorten'>*ShortenURL*:</section>
# > **`ShortenURL`** initialises a request to shorten a URL using the [**Google URL Shortener**](http://goo.gl/) API. When this request is successful, the shortened URL is sent to the client with the correct `sessionID` via [**WebSocket**](http://www.websocket.org/).
ShortenURL = (url, sessionID) ->
  googl.shorten url, (shortUrl) ->
    (require './server').io.sockets.in(sessionID).emit 'urlShortened', shortURL: shortUrl.id
    
# ___
# ## Exports:

# The [**`ShortenURL`**](#shorten) function is added to the global *root* object.
root = exports ? this
root.shortenURL = ShortenURL