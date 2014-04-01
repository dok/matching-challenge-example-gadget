var gulp = require('gulp');
var gutil = require('gulp-util');
var react = require('gulp-react');
var coffee = require('gulp-coffee');
var fs = require('fs-extra');

gulp.task('common', function() {
  return gulp.src('../../client/challenges.coffee')
    .pipe(gulp.dest('./src/plugins'));
});

gulp.task('coffee', function() {
  gulp.src([
    '!./src/views/**/*.coffee',
    './src/**/*.coffee'
  ])
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('./assets'));
});

gulp.task('coffee-react-views', function() {
  gulp.src('./src/views/**/*.coffee')
    .pipe(coffee({ bare: true, header: false }).on('error', gutil.log))
    .pipe(react())
    .pipe(gulp.dest('./assets/views'));
});

gulp.task('vendor', function() {
  return gulp.src('./src/vendor/**')
    .pipe(gulp.dest('./assets/vendor'));
});

// TEMP until `index.html` in root is in production
gulp.task('index', function() {
  return gulp.src('./src/index.html')
    .pipe(gulp.dest('./assets'));
});

gulp.task('default', function() {
  // TODO This means delete everything but real assets.
  // This won't be needed when `index.html` in root is
  // in production
  fs.removeSync('./assets/sample-data');
  fs.removeSync('./assets/vendor');
  fs.removeSync('./assets/views');
  fs.removeSync('./assets/sample.js');
  fs.removeSync('./assets/vent.js');

  gulp.run('common', 'coffee', 'coffee-react-views', 'vendor', 'index');
});
