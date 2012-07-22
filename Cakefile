{spawn, exec} = require 'child_process'

task 'compile', 'compile everything', ->
  exec 'coffee -o javascript/client/ -cw coffeescript/client/'
  exec 'coffee -j javascript/raytracer/raytracer.js -cw coffeescript/raytracer/'
  exec 'coffee -o javascript/server/ -cw coffeescript/server/'
  exec 'coffee -o javascript/testing/ -cw coffeescript/testing/'
  console.log 'Done compile, now watching for changes...'
  
task 'docs', 'create docs', ->
  exec 'docco coffeescript/client/*.coffee'
  
  exec 'docco coffeescript/raytracer/camera.coffee'
  
  exec 'docco coffeescript/raytracer/geometry/animatedTransform.coffee'
  exec 'docco coffeescript/raytracer/geometry/differentialGeometry.coffee'
  exec 'docco coffeescript/raytracer/geometry/geometry.coffee'
  exec 'docco coffeescript/raytracer/geometry/matrix.coffee'
  exec 'docco coffeescript/raytracer/geometry/transform.coffee'
  
  exec 'docco coffeescript/raytracer/shape/shape.coffee'
  exec 'docco coffeescript/raytracer/shape/triangle.coffee'
  
  exec 'docco coffeescript/raytracer/utils/math.coffee'
  
  exec 'docco coffeescript/server/*.coffee'
  console.log 'Done docs.'
  
task 'lint', 'run Coffeelint on all CoffeeScripts', ->
  lint = exec "coffeelint -r coffeescript"
  lint.stdout.on 'data', (data) -> console.log data.toString().trim()
  lint.stderr.on 'data', (data) -> console.log data.toString().trim()
  console.log 'Done lint'
  
task 'all', 'compile everything and create the docs', ->
  console.log 'Running compile...'
  invoke 'compile'
  console.log 'Running docs...'
  invoke 'docs'
  console.log 'Running Coffeelint'
  invoke 'lint'