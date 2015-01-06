gulp = require 'gulp'
# express = require 'express'
coffee = require 'gulp-coffee'
jade = require 'gulp-jade'
csso = require 'gulp-csso'
stylus = require 'gulp-stylus'
nib = require 'nib'
myth = require 'gulp-myth'
sourcemaps = require 'gulp-sourcemaps'
autoprefixer = require 'gulp-autoprefixer'
imagemin = require 'gulp-imagemin'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
glob = require 'glob'
path = require 'path'
browserSync = require 'browser-sync'
minifyHTML = require 'gulp-minify-html'
minifyCSS = require 'gulp-minify-css'
reload = browserSync.reload
watch = require 'gulp-watch'
paths =
	stylus: 
		from: ['./dev/stylus/**/*.styl']
		to: './build/css/'
	coffee: 
		from: ['./dev/coffee/**/*.coffee']
		to: './build/js/'
	jade:
		from: ['./dev/*.jade','./dev/**/*.jade']
		to: './build/'
	img: 
		from: ['./dev/img/**/*.{jpg,jpeg,png,gif}']
		to: './build/img/'
for type in paths
	fs.mkdirSync type.to if !fs.existsSync type.to

gulp.task 'stylus', ->
	gulp.src paths.stylus.from
		.pipe stylus use: nib()
		.pipe concat 'all.min.css'
		.pipe sourcemaps.init()
		# .pipe autoprefixer('last 15 version')
		.pipe myth()
		.pipe minifyCSS()
		.pipe sourcemaps.write()
		.pipe gulp.dest paths.stylus.to
		.on 'error', console.log
		.pipe reload {stream: true}
gulp.task 'coffee', ->
	gulp.src paths.coffee.from
		.pipe coffee bare:true
		.pipe concat 'all.min.js'
		.pipe sourcemaps.init()
		.pipe uglify()
		.pipe gulp.dest paths.coffee.to
		.pipe sourcemaps.write()
		.on 'error', console.log
		.pipe reload {stream: true}
gulp.task 'jade', ->
	console.error paths.jade.to
	gulp.src paths.jade.from
		.pipe jade pretty:true
		.pipe minifyHTML()
		.pipe gulp.dest paths.jade.to
		.pipe reload {stream: true}
gulp.task 'imagemin', ->
	gulp.src paths.img.from
		.pipe imagemin()
		.on 'error', console.log
		.pipe gulp.dest paths.img.to
		.pipe reload {stream: true}
		
gulp.task 'browser-sync', ->
	browserSync server:	
			baseDir: './build'
			routes: 
				'/bower_components': '../bower_components'
			logPrefix: 'FastDev'

gulp.task 'default', ['browser-sync','stylus','coffee','jade','imagemin'], ->
	gulp.watch paths.stylus.from, ['stylus']
	gulp.watch paths.coffee.from, ['coffee']
	gulp.watch paths.jade.from, ['jade']
	gulp.watch paths.img.from, ['imagemin']