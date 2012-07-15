{exec} = require 'child_process'

task 'compile', 'compile everything', ->
  exec "coffee -o javascript/ -cw coffeescript/"
  console.log("Done compile, now watching for changes...")
  
task 'docs', 'create docs', ->
  exec "docco coffeescript/client/*.coffee"
  
  exec "docco coffeescript/raytracer/camera.coffee"
  
  exec "docco coffeescript/raytracer/geometry/animatedTransform.coffee"
  exec "docco coffeescript/raytracer/geometry/differentialGeometry.coffee"
  exec "docco coffeescript/raytracer/geometry/geometry.coffee"
  exec "docco coffeescript/raytracer/geometry/matrix.coffee"
  exec "docco coffeescript/raytracer/geometry/transform.coffee"
  
  exec "docco coffeescript/raytracer/shape/shape.coffee"
  exec "docco coffeescript/raytracer/shape/triangle.coffee"
  
  exec "docco coffeescript/raytracer/utils/math.coffee"
  
  exec "docco coffeescript/server/*.coffee"
  console.log("Done docs.")
  
task 'all', 'compile everything and create the docs', ->
  console.log("Running compile...")
  invoke 'compile'
  console.log("Running docs...")
  invoke 'docs'