module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    sass:
      tooltip:
        options:
          sourcemap: 'none'
          bundleExec: true
          style: 'expanded'
        files:
          'styles/tooltip.css': 'styles/tooltip.scss'

    coffee:
      tooltip:
        files:
          'lib/tooltip.js': 'src/tooltip.coffee'

    watch:
      styles:
        files: ['styles/*.scss']
        tasks: ['sass']
      scripts:
        files: ['src/*.coffee', 'spec/*.coffee']
        tasks: ['coffee']


  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['sass', 'coffee', 'watch']
