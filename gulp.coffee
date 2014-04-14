gulp = require('gulp')
gutil = require('gulp-util')
autoprefixer = require("gulp-autoprefixer")
minifycss = require("gulp-minify-css")
rename = require("gulp-rename")
clean = require("gulp-clean")
notify = require("gulp-notify")
lr = require("tiny-lr")
server = lr()
refresh = require('gulp-livereload')
ngHtml2Js = require("gulp-ng-html2js")
minifyHtml = require("gulp-minify-html")
concat = require("gulp-concat")
uglify = require("gulp-uglify")
less = require('gulp-less')
gulpif = require('gulp-if')
coffeelint = require('gulp-coffeelint')
coffee = require('gulp-coffee')
inject = require('gulp-inject')
rev = require('gulp-rev')
sprite = require('css-sprite').stream
runSequence = require('run-sequence')
plumber = require('gulp-plumber')
libnotify = require('libnotify')
browserify = require('gulp-browserify')
toml = require('gulp-toml')
json = JSON.stringify

modules=[
  "vendor/angular/angular.js",
  "vendor/angular-sanitize/angular-sanitize.js",
  "vendor/angular-animate/angular-animate.js",
  "vendor/angular-touch/angular-touch.js",
  "vendor/angular-translate/angular-translate.js",
  # "vendor/angular-bootstrap/ui-bootstrap-tpls.js",
  "vendor/angular-ui-router/release/angular-ui-router.js",
  "vendor/angular-ui-utils/ui-utils.js",
  "vendor/angular-gestures/gestures.js",
  "libs/cs_cz.js"
]

dirs=
  "src":"NGMZDOS"
  "dest":"build"
  "tmp":"tmp"

config =
  "less":
    "src": "#{dirs.src}/app/less/main.less"
    "dest": "#{dirs.dest}"
    "watch": "#{dirs.src}/app/**/*.less"
    "sprites": "#{dirs.src}/app/less/"
  "cs":
    "src": "#{dirs.src}/**/*.coffee"
    "dest": "#{dirs.dest}"
    "watch": "#{dirs.src}/**/*.coffee"
  "html":
    "src": "#{dirs.src}/app/**/*.tpl.html"
    "dest": "#{dirs.tmp}"
    "concat": "templates.js"
    "watch": "#{dirs.src}/app/**/*.html"
  "index":
    "src": "#{dirs.src}/index.html"
    "dest": "./"
  "font":
    "src": ["#{dirs.src}/fonts/**/*","bower_components/font-awesome/fonts/**/*"]
    "dest": "#{dirs.dest}/fonts"
  "img":
    "src":"#{dirs.src}/**/*.png"
    "dest":"#{dirs.dest}"

prod = true
###
DEAFULT TASK
###
gulp.task 'default', ->
  runSequence "CLEAN", [
    "FONTS"
  ],
    "INJECT"
###
DEVEL
###
gulp.task 'dev',->
  prod = false
  runSequence "default"
  coffee=["COFFEE"]
  # less=["LESS"]
  server.listen 35729, (error) ->
    return console.log(error) if error
    # gulp.watch([
    #   config.less.watch
    #   config.img.src
    # ], less)

    gulp.watch [
      config.cs.src
    ],coffee

###
PRODUCTION
###
gulp.task 'prod', ['default'],->
  prod = true

###
CLEAN
###
gulp.task 'CLEAN', ->
  gulp.src([
    dirs.dest,
    "#{config.index.dest}index.html",
    "tmp"],
    read: false)
  .pipe(clean())


gulp.task 'parseConfig', ->

  src="./config.toml"

  if !prod
    src="./config.toml"

  #facebookConfig
  gulp.src(src)
  .pipe(toml({to: json, ext: '.json'}))
  .pipe(rename "config.json")
  .pipe(gulp.dest(dirs.src))
  .pipe(gulpif(!prod,refresh(server)))

###
LESS
###
# gulp.task 'LESS',["SPRITES"], ->
#   gulp.src(config.less.src)
#   .pipe(plumber())
#   .pipe(require('gulp-debug')())
#   .pipe(less())
#   .pipe(autoprefixer(
#     "last 2 version",
#     "safari 5",
#     "ie 9",
#     "opera 12.1",
#     "ios 6",
#     "android 4"
#   ))
#   .pipe(gulpif(prod,minifycss()))
#   .pipe(gulpif(prod, rename suffix: ".min"))
#   .pipe(gulpif(prod, rev()))
#   .pipe(gulp.dest(config.less.dest))
#   .pipe(gulpif(!prod,refresh(server)))
###
COFFEE
###
# gulp.task 'COFFEE', ["parseConfig","HTML2JS"],->
gulp.task 'COFFEE', ["parseConfig"],->
  gulp.src(config.cs.src)
  .pipe(plumber())
  .pipe(coffeelint())
  .pipe(coffeelint.reporter())
  gulp.src('NGMZDOS/index.coffee', { read: false })
  .pipe(plumber())
  .pipe(browserify({
    debug: !prod
    insertGlobals : true,
    transform: ['coffeeify', 'brfs','envify']
    extensions: ['.coffee'],
    shim:
      angular:
          path: 'bower_components/angular/angular.js',
          exports: 'angular'
          
    noParse: modules
  }))
  .pipe(gulpif(prod,rename('app.js',suffix: ".min")))
  .pipe(gulpif(!prod,rename('app.js')))
  .pipe(gulpif(prod, rev()))
  .pipe(gulpif(prod,uglify mangle:false))
  .pipe(gulp.dest(config.cs.dest))
  .pipe(gulpif(!prod,refresh(server)))
###
IMG SPRITES
###
# gulp.task 'SPRITES', ->
#   gulp.src(config.img.src)
#   .pipe(sprite(
#     name: 'sprite.png'
#     style: 'sprites.less',
#     cssPath: 'images/',
#     processor: 'less'
#   ))
#   .pipe(gulpif('*.png', gulp.dest(config.img.dest)))
#   .pipe(gulpif('*.less', gulp.dest(config.less.sprites)))
#   .pipe(gulpif(!prod,refresh(server)))
###
HTML
###
gulp.task 'HTML2JS', ->
  gulp.src(config.html.src)
  .pipe(gulpif(prod,minifyHtml {
    empty: true
    spare: true
    quotes: true
  }))
  .pipe(ngHtml2Js({
    moduleName: "templates"
#        prefix: "build/"
  }))
  .pipe(concat(config.html.concat))
  .pipe(gulpif(prod,uglify()))
  .pipe(gulpif(prod,rev()))
  .pipe(gulp.dest(config.html.dest))
  .pipe(gulpif(!prod,refresh(server)))
###
FONTS
###
gulp.task 'FONTS', ->
  gulp.src(config.font.src).pipe gulp.dest(config.font.dest)
###
COPY
###
gulp.task 'COPY', ->
  gulp.src(config.index.src).pipe gulp.dest(config.index.dest)

###
INJECT
###
gulp.task 'INJECT', ["COFFEE"],->
  gulp.src("#{dirs.dest}/**/*",{read:false})
  .pipe(inject(
    config.index.src,
    addRootSlash: false
    ignorePath: ["/"]
  ))
  .pipe(gulp.dest(config.index.dest))
  .pipe(gulpif(!prod,refresh(server)))