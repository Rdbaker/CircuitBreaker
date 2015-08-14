module.exports = function(karma) {
  karma.set({
    frameworks: ['jasmine'],

    // add all your files here,
    // including non-commonJS files you need to load before your test cases
    files: [
      //we need to include lib for anything that we shim
      //This is an ordered dependency list
      'node_modules/lodash/lodash.js',
      'tests/**/*.coffee'
    ],

    // add preprocessor to the files that should be
    // processed via browserify
    preprocessors: {
      'tests/**/*.coffee': ['coffee']
    },

    //we may be able to modify the browser on the fly with gulp like adding ie8
    browsers: ['PhantomJS'],

    // see what is going on
    logLevel: 'LOG_DEBUG',

    singleRun: true,

    reporters: ['spec'],
  });

};
