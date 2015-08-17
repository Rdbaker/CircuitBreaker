module.exports = function(karma) {
  karma.set({
    frameworks: ['jasmine', 'browserify'],

    files: [
      'tests/**/*.coffee'
    ],

    preprocessors: {
      'tests/**/*.coffee': ['browserify']
    },

    browserify: {
      debug: true,
      transform: ['coffeeify'],
      extentions: ['.coffee']
    },

    browsers: ['PhantomJS'],

    logLevel: 'LOG_DEBUG',

    singleRun: true,

    reporters: ['spec'],
  });

};
