'use strict'

var gulp        = require('gulp')
  , purescript  = require('gulp-purescript')
, runSequence = require('run-sequence')
, clean = require('gulp-clean')
, gutil = require('gulp-util')
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
            main: 'Test.Main',
            output: 'Main.js'
        }
    }
}
;
// https://github.com/purescript-contrib/purescript-contravariant/blob/master/gulpfile.js
// https://github.com/purescript-contrib/purescript-free/blob/master/gulpfile.js

var compile = function(paths, options) {
    return function() {
        // We need this hack for now until gulp does something about
        // https://github.com/gulpjs/gulp/issues/71
        var psc = purescript.psc(options);
        psc.on('error', function(e) {
            console.error(e.message);
            psc.end();
        });
        return gulp.src(paths.src)
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

gulp.task('make', function() {
    return compile(purescript.pscMake);
});

gulp.task('browser', function() {
    return compile(purescript.src, purescript.options);
});

// gulp.task('docs-Data.Contravariant', docs('Data.Contravariant'));

// gulp.task('docs', ['docs-Data.Contravariant']);

gulp.task('watch-browser', function() {
    gulp.watch(paths.src, function() {runSequence('browser', 'docs')});
});

gulp.task('watch-make', function() {
    gulp.watch(paths.src, function() {runSequence('make', 'docs')});
});

gulp.task('default', function() {runSequence('make', 'docs')});
