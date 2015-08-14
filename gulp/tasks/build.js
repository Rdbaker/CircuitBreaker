var gulp = require('gulp');
var config = require('../config');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');

gulp.task('build', function() {
  console.log(config.dirs.src + '/circuitbreaker.coffee');
  gulp.src(config.dirs.src + '/circuitbreaker.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe(rename('circuitbreaker.js'))
    .pipe(gulp.dest(config.dirs.dest));
});
