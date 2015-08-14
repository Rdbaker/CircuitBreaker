# CircuitBreaker
[![Build Status](https://travis-ci.org/Rdbaker/CircuitBreaker.svg?branch=master)](https://travis-ci.org/Rdbaker/CircuitBreaker)
An implementation of the circuit breaker programming pattern for use in client side javascript.



# Contributing
All contributions are greatly appreciated! Please fork and make a pull request to this repository. Try your best to keep the coverage at 100%!


## Setup
You'll first need to install the dependencies with npm.

```
npm install
```

Then you'll need to build the files.

```
node ./node_modules/gulp/bin/gulp.js build
```

This will take the files in `./src/*.coffee` and build them to be `./dist/circuitbreaker.js`


## Testing
To run the tests, just use the command:

```
node ./node_modules/gulp/bin/gulp.js test
```
