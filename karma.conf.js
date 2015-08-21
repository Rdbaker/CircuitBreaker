module.exports = function(karma) {
  karma.set({
    frameworks: ['browserify', 'jasmine'],

    files: [
      'src/tests/**/*.coffee'
    ],

    preprocessors: {
      'src/tests/**/*.coffee': ['browserify']
    },

    browserify: {
      debug: true,
      extentions: ['.coffee']
    },

    browsers: ['PhantomJS'],

    logLevel: 'LOG_DEBUG',

    singleRun: true,

    reporters: ['spec'],
  });

};
