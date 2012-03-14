{exec} = require 'child_process'

task 'build', 'build everything', ->
  for j in ['./*.js', './*/*.js']
    exec "rm #{j}"
  for x in ['./*.coffee', './*/*.coffee']
    exec "coffee -c #{x}"