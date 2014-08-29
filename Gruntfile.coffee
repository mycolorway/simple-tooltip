module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    sass:
      tooltip:
        options:
          style: 'expanded'
        files:
          'styles/tooltip.css': 'styles/tooltip.scss'

    coffee:
      tooltip:
        files:
          'lib/tooltip.js': 'src/tooltip.coffee'
      spec:
        files:
          'spec/tooltip-spec.js': 'spec/tooltip-spec.coffee'

    watch:
      styles:
        files: ['styles/*.scss']
        tasks: ['sass']
      scripts:
        files: ['src/*.coffee', 'spec/*.coffee']
        tasks: ['coffee']
      jasmine:
        files: [
          'styles/tooltip.css'
          'lib/tooltip.js'
          'specs/*.js'
        ],
        tasks: 'jasmine:test:build'

    jasmine:
      terminal:
        src: ['lib/tooltip.js']
        options:
          specs: 'spec/tooltip-spec.js'
          vendor: [
            'vendor/bower/jquery/dist/jquery.min.js'
            'vendor/bower/simple-module/lib/module.js'
          ]
      test:
        src: ['lib/tooltip.js']
        options:
          outfile: 'spec/index.html'
          styles: 'styles/tooltip.css'
          specs: 'spec/tooltip-spec.js'
          vendor: [
            'vendor/bower/jquery/dist/jquery.min.js'
            'vendor/bower/simple-module/lib/module.js'
          ]

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'

  grunt.registerTask 'default', ['sass', 'coffee', 'jasmine:test:build', 'watch']
  grunt.registerTask 'test', ['sass', 'coffee', 'jasmine:terminal']
