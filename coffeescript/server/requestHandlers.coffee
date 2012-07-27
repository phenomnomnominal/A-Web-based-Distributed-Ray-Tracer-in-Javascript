# *requestHandlers.coffee* provides functions for specific operation, namely generating HTML from [**Jade**](http://jade-lang.com/) templates, and performing POST functionality for uploading and retrieving render operations.
# ___

# ## Requires:
# Functionality in *requestHandlers.coffee* requires access to the following packages:

# * [`database`](database.html) - *Database functionality for insertion and retrieval of render data*
database = require './database'
# * [`sceneHandler`](sceneHandler.html) - *[**COLLADA**](http://www.collada.org) scene description file parsing*
sceneHandler = require './sceneHandler'
# * [`urlShorten`](urlShorten.html) - *URL Shortening funcitonality*
urlShorten = require './urlShorten'
# ___

# ## Constants:
# Some constants are required for this script:

# > * **`VIEW_LOCATION`** - *Directory location for [**Jade**](http://jade-lang.com/) view templates*
VIEW_LOCATION = __dirname + '/../../views/'

# ___

# ## Functions:

# ### <section id='master'>*RenderMaster*:</section>
# > **`RenderMaster`** takes the [**Jade**](http://jade-lang.com/) template from *'/views/master.jade'* and returns the generated HTML from the template.
RenderMaster = (response) ->
  response.render VIEW_LOCATION + 'master', title: 'Master'

# ### <section id='upload'>*InsertRenderIntoDatabase*:</section>
# > **`InsertRenderIntoDatabase`** sends the [**COLLADA**](http://www.collada.org) from the `renderUpload` object to [*sceneHandler.coffee*](sceneHandler.html) for parsing and inserts the resulting object into the database. A shortened URL that contains the unique identified of the render is returned to the client with the correct `sessionID`.
InsertRenderIntoDatabase = (response, render, sessionID) ->
  render.sceneDescription = sceneHandler.parse render.sceneDescription
  database.insert render.uuid, render
  urlShorten.shortenURL render.url, sessionID

# ### <section id='render'>*RenderSlave*:</section>
# > **`RenderSlave`** takes the [**Jade**](http://jade-lang.com/) template from *'/views/index.jade'* and returns the generated HTML from the template.
RenderSlave = (response) ->
  response.render VIEW_LOCATION + 'index', title: 'Slave'
  
# ### <section id='get-render'>*GetRenderFromDatabase*:</section>
# > **`GetRenderFromDatabase`** searches the database for the render described by the `getRender` object and returns it to the client with the correct `sessionID`.
GetRenderFromDatabase = (response, getRender, sessionID) ->
  database.find getRender.renderId, sessionID

# ### <section id='test'>*RenderTest*:</section>
# > **`RenderTest`** takes the [**Jade**](http://jade-lang.com/) template from *'/views/test.jade'* and returns the generated HTML from the template.
RenderTest = (response) ->
  response.render VIEW_LOCATION + 'test', layout: false

# ___
# ## Exports:

# The [**`RenderMaster`**](#master), [**`InsertRenderIntoDatabase`**](#insert), [**`RenderSlave`**](#render), [**`GetRenderFromDatabase`**](#get-render) and [**`RenderTest`**](#test) functions are added to the global `root` object.
root = exports ? this
root.master = RenderMaster
root.upload = InsertRenderIntoDatabase
root.render = RenderSlave
root.getRender = GetRenderFromDatabase
root.test = RenderTest