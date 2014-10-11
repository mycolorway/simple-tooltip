module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    sass:
      styles:
        options:
          bundleExec: true
          style: 'expanded'
          loadPath: '/usr/bin/sass'
          sourcemap: 'none'

        files:
          'styles/tooltip.css': 'styles/tooltip.scss'

    coffee:
      src:
        options:
          bare: true
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
        tasks: ['coffee', 'umd']
      jasmine:
        files: [
          'styles/checkbox.css'
          'lib/checkbox.js'
          'specs/*.js'
        ],
        tasks: 'jasmine:test:build'

    jasmine:
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

    umd:
      all:
        src: 'lib/tooltip.js'
        template: 'umd.hbs'
        amdModuleId: 'simple-tooltip'
        objectToExport: 'tooltip'
        globalAlias: 'tooltip'
        deps:
          'default': ['$', 'SimpleModule']
          amd: ['jquery', 'simple-module']
          cjs: ['jquery', 'simple-module']
          global:
            items: ['jQuery', 'SimpleModule']
            prefix: ''

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-umd'

  grunt.registerTask 'default', ['sass', 'coffee', 'umd', 'jasmine:test:build', 'watch']
  grunt.registerTask 'test', ['sass', 'coffee', 'jasmine:terminal']
