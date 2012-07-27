# *requestHandlers.coffee* provides functions for specific operation, namely generating HTML from [**Jade**](http://jade-lang.com/) templates, and performing POST functionality for uploading and retrieving render operations.
# ___

# ## Requires:
# Functionality in *requestHandlers.coffee* requires access to the following packages:

# * [`database`](database.html) - Database functionality for insertion and retrieval of render data
database = require './database'
# * [`sceneHandler`](sceneHandler.html) - [**COLLADA**](http://www.collada.org) scene description file parsing
sceneHandler = require './sceneHandler'
# * [`urlShorten`](urlShorten.html) - URL Shortening funcitonality
urlShorten = require './urlShorten'
# ___

# ## Request Handler functions:

# ### <section id='master'>*renderMaster*:</section>
# > **`renderMaster`** takes the [**Jade**](http://jade-lang.com/) template from *'/views/master.jade'* and returns the generated HTML from the template.
renderMaster = (response) ->
  response.render 'master', title: 'Master'

# ### <section id='upload'>*uploadRenderFile*:</section>
# > **`uploadRenderFile`** sends the [**COLLADA**](http://www.collada.org) from the `renderUpload` object to [*sceneHandler.coffee*](sceneHandler.html) for parsing and inserts the resulting object into the database. A shortened URL that contains the unique identifier of the render is returned to the client with the correct `sessionID`.
uploadRenderFile = (response, render, sessionID) ->
  render.sceneDescription = sceneHandler.parse render.sceneDescription
  database.insert render.uuid, render
  urlShorten.shortenURL render.url, sessionID

# ### <section id='render'>*renderSlave*:</section>
# > **`renderSlave`** takes the [**Jade**](http://jade-lang.com/) template from *'/views/index.jade'* and returns the generated HTML from the template.
renderSlave = (response) ->
  response.render 'index', title: 'Slave'
  
# ### <section id='get-render'>*getRenderFromDatabase*:</section>
# > **`getRenderFromDatabase`** searches the database for the render described by the `getRender` object and returns it to the client with the correct `sessionID`.
getRenderFromDatabase = (response, getRender, sessionID) ->
  database.find getRender.renderId, sessionID

# ### <section id='test'>*renderTest*:</section>
# > **`renderTest`** takes the [**Jade**](http://jade-lang.com/) template from *'/views/test.jade'* and returns the generated HTML from the template.
renderTest = (response) ->
  response.render 'test', layout: false

# ___
# ## Exports:

# The [**`renderMaster`**](#master), [**`uploadRenderFile`**](#upload), [**`renderSlave`**](#render), [**`getRenderFromDatabase`**](#get-render) and [**`renderTest`**](#test) functions are added to the global `root` object.
root = exports ? this
root.master = renderMaster
root.upload = uploadRenderFile
root.render = renderSlave
root.getRender = getRenderFromDatabase
root.test = renderTest