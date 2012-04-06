{exec} = require 'child_process'

task 'build', 'build everything', ->
  for j in ['./*.js', './public/*.js', './public/client/*.js', './test/test.js']
    exec "rm #{j}"
  for x in ['./*.coffee', './*/*.coffee', './*/*/*.coffee']
    exec "coffee -c #{x}"