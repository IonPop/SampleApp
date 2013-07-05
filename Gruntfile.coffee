module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-express'
  
  connect = require('connect')
  server = connect.createServer()
  
  grunt.initConfig 
    pkg: grunt.file.readJSON('package.json')
	
    jshint:
      build: 
        options: 
          jshintrc: '.jshintrc'
        src: ['app/js/**/*.js']

    coffee:
      compile:
        options:
          bare: true
        files: [
          expand:true
          cwd: 'app/'
          src: ['**/*.coffee']
          dest: 'app/'
          ext: '.js'	
          ]
          
    watch:
      files: 'app/**'
      tasks: ['coffee:compile']
     
    express: 
      start:
        options: 
          port: 80,
          bases: [
            'app'
            'test'
            ]  

  grunt.registerTask 'connect', 'Start a custom static web server.' , ()  ->
    grunt.log.writeln 'Starting static web server in "www-root" on port 9001.'
    server.use '/',connect.static('app')
    server.use '/',connect.static('test')
    server.listen 80
    @.async()
	
  grunt.registerTask 'compile', ['coffee:compile','jshint']
  grunt.registerTask 'server', ['express','express-keepalive']	
  grunt.registerTask 'test' ,['karma:dev']
  grunt.registerTask 'test:single' ,['karma:single']   
