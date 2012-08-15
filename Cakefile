{spawn, exec} = require 'child_process'

task 'compile', 'compile everything', ->
  exec 'coffee -o javascript/client/ -cw coffeescript/client/'
  files = ['primitive/primitive.coffee',
           'accelerators/kdtree.coffee',
           'camera.coffee',
           'filter.coffee',
           'geometry/',
           'integrators/',
           'intersection.coffee',
           'lights/light.coffee',
           'lights/areaLight.coffee',
           'lights/diffuseAreaLight.coffee',
           'lights/distantLight.coffee',
           'lights/infiniteAreaLight.coffee',
           'lights/pointLight.coffee',
           'lights/spotLight.coffee',
           'materials.coffee',
           'utils/tasks.coffee',
           'renderers/',
           'samplers/',
           'scene.coffee',
           'setup.coffee',
           'shape/',
           'spectrum.coffee'
           'specular.coffee',
           'utils/math.coffee']
  joinOrder = ''
  joinOrder += "'coffeescript/raytracer/#{file}' " for file in files
  exec "coffee -j javascript/raytracer/raytracer.js -cw #{joinOrder}"
  exec 'coffee -o javascript/raytracer/ -cw coffeescript/raytracer/index.coffee'
  exec 'coffee -o javascript/server/ -cw coffeescript/server/'
  exec 'coffee -o javascript/testing/ -cw coffeescript/testing/'
  console.log 'Done compile, now watching for changes...'
  
task 'docs', 'create docs', ->
  exec 'docco coffeescript/client/*.coffee'
  
  exec 'docco coffeescript/raytracer/camera.coffee'

  exec 'docco coffeescript/raytracer/scene.coffee'
  
  exec 'docco coffeescript/raytracer/geometry/*.coffee'
  
  exec 'docco coffeescript/raytracer/shape/*.coffee'
  
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