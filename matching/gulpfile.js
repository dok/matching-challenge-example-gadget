var gulp = require('gulp');
var gutil = require('gulp-util');
var react = require('gulp-react');
var coffee = require('gulp-coffee');
var fs = require('fs-extra');

gulp.task('styles', function() {
  return gulp.src('src/gadget.css')
    .pipe(gulp.dest('./lib/gadget.css'));
});

gulp.task('coffee', function() {
  gulp.src([
    '!./src/views/**/*.coffee',
    './src/**/*.coffee'
  ])
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('./lib'));
});

gulp.task('coffee-react-views', function() {
  gulp.src('./src/views/**/*.coffee')
    .pipe(coffee({ bare: true, header: false }).on('error', gutil.log))
    .pipe(react())
    .pipe(gulp.dest('./lib/views'));
});

gulp.task('vendor', function() {
  return gulp.src('./src/vendor/**')
    .pipe(gulp.dest('./lib/vendor'));
});

// TEMP until `index.html` in root is in production
gulp.task('index', function() {
  return gulp.src('./src/index.html')
    .pipe(gulp.dest('./lib'));
});

gulp.task('default', function() {
  fs.removeSync('./lib');

  gulp.run('coffee', 'coffee-react-views', 'vendor', 'index');
});
