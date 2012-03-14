### 
Module dependencies 
###

express = require("express")
routes = require("./routes")

raytracer = module.exports = express.createServer()

### 
Configuration 
###

raytracer.configure ->
  raytracer.set "views", __dirname + "/views"
  raytracer.set "view engine", "jade"
  raytracer.use express.bodyParser()
  raytracer.use express.cookieParser()
  raytracer.use express.session(
    secret: "phenomnomnominal"
    id: new Date()
    )
  raytracer.use express.methodOverride()
  raytracer.use raytracer.router
  raytracer.use express.static(__dirname + "/public")
  return
  

raytracer.configure "development", ->
  raytracer.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
  return

raytracer.configure "production", ->
  raytracer.use express.errorHandler()
  return

### 
Routes 
###

raytracer.get "/", routes.index
raytracer.listen 3000
console.log "Express server listening on port %d in %s mode", raytracer.address().port, raytracer.settings.env