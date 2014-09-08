'use strict'

var gulp        = require('gulp')
  , purescript  = require('gulp-purescript')
, runSequence = require('run-sequence')
, clean = require('gulp-clean')
, gutil = require('gulp-util')
 , shell = require('gulp-shell')
, plumber = require('gulp-plumber')
, config = {
    clean: ['dist'],
    purescript: {
        src: [
            'bower_components/purescript-*/src/**/*.purs*',
            'src/**/*.purs'
        ],
        examples: 'examples/**/*.purs',
        dest: 'dist',
        docgen: 'MODULE.md',
        options: {
            main: 'Helper.Angular.Main',
            // modules: 'Helper.Angular.Main',
            output: 'dist/Main.js'
        },
        core: {options: {
                    main: 'Helper',
                    // modules: 'Helper.Angular.Main',
                    output: 'dist/Core.js'
                }}
    }
};

var paths = {
    src: [
        'src/**/*.purs',
        'bower_components/purescript-*/src/**/*.purs'
    ],
    dest: '.'
}
// https://github.com/purescript-contrib/purescript-contravariant/blob/master/gulpfile.js
// https://github.com/purescript-contrib/purescript-free/blob/master/gulpfile.js

var onError = function (err) {
  gutil.beep();
  console.log(err.message);
};

var compile = function(paths, options) {
    return function() {
        // We need this hack for now until gulp does something about
        // https://github.com/gulpjs/gulp/issues/71
        var psc = purescript.psc(options);
        return gulp.src(paths.src)
            .pipe(plumber({
              errorHandler: onError
            }))
            .pipe(psc)
            .pipe(gulp.dest(paths.dest || 'js'));
    };
};

function docs (target) {
    return function() {
        return gulp.src(paths.docs[target].src)
            .pipe(purescript.docgen())
            .pipe(gulp.dest(purescript.docgen));
    }
}

gulp.task('run', ['core'], function () {
    gulp.src('')
    .pipe(plumber({
      errorHandler: onError
    }))
    .pipe(shell('node dist/Core.js'))
    // .pipe(shell('node dist/Main.js'))
    .on('finish', function () {
      console.log('Done.');
    })
})

gulp.task('clean', function(){
  return (
    gulp.src(config.clean, {read: false}).
      pipe(clean())
  );
});
gulp.task('make', compile(purescript.pscMake));

gulp.task('browser', compile(paths, config.purescript.options));
gulp.task('core', compile(paths, config.purescript.core.options));

// gulp.task('docs-Data.Contravariant', docs('Data.Contravariant'));

// gulp.task('docs', ['docs-Data.Contravariant']);

gulp.task('watch-run', function() {
    gulp.watch(paths.src, function() {runSequence('clean', 'browser', 'run')});
});

gulp.task('watch-browser', function() {
    gulp.watch(paths.src, function() {runSequence('clean', 'browser')});
    // gulp.watch(paths.src, ['browser']);
    // gulp.watch(paths.src, function() {runSequence('browser', 'docs')});
});

gulp.task('watch-core', function() {
    gulp.watch(paths.src, function() {runSequence('core', 'run')});
});

gulp.task('watch-make', function() {
    gulp.watch(paths.src, function() {runSequence('make', 'docs')});
});

// gulp.task('default', function() {runSequence('make', 'docs')});
// gulp.task('default', ['clean', 'browser', 'run']);
gulp.task('default', function() {
    gulp.watch(paths.src, ['clean', 'run']);
    // gulp.watch(paths.src, ['clean', 'browser', 'run']);
});
