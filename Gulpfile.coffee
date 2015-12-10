gulp = require 'gulp'
gutil = require 'gulp-util'
coffeelint = require 'gulp-coffeelint'
coffeelintThreshold = require 'gulp-coffeelint-threshold'
jshint = require 'gulp-jshint'
jshintBamboo = require 'gulp-jshint-bamboo'

lintError = new Error "Linting Error"

gulp.task 'coffeelint', ()->
	gulp.src ['./**/*.coffee', '!./node_modules/**']
		.pipe coffeelint()
		.pipe coffeelint.reporter()
		.pipe coffeelintThreshold -1, 0, (numberOfWarnings, numberOfErrors)->
			gutil.beep()
			throw lintError

gulp.task 'jshint', ()->
	gulp.src [
		'./**/*.js',
		'./**/*.ejs',
		'!./node_modules/**',
		'!./static/bower_components/**',
		'!./static/map/**'
	]
		.pipe jshint.extract()
  	.pipe jshint()
  	.pipe jshintBamboo()

gulp.task 'lint', ['jshint', 'coffeelint']
gulp.task 'default', ['lint']
gulp.task 'test', ['lint']
