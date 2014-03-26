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
  fs.removeSync('./assets/lib/plugins');

  gulp.src([
    '!./src/views/**/*.coffee',
    './src/**/*.coffee'
  ])
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('./assets/lib'));
});

gulp.task('coffee-react-views', function() {
  fs.removeSync('./assets/lib/views');

  gulp.src('./src/views/**/*.coffee')
    .pipe(coffee({ bare: true, header: false }).on('error', gutil.log))
    .pipe(react())
    .pipe(gulp.dest('./assets/lib/views'));
});

gulp.task('vendor', function() {
  fs.removeSync('./assets/lib/vendor');

  return gulp.src('./src/vendor/**')
    .pipe(gulp.dest('./assets/lib/vendor'));
});

gulp.task('default', function() {
  gulp.run('common', 'coffee', 'coffee-react-views', 'vendor');
});
