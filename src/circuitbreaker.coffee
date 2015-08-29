'use strict'

$ = require('jquery')
_ = require('lodash')
urijs = require('URIjs')
Configuration = require('./configuration.coffee')

class CircuitBreaker
  # Constructor
  # -----------
  constructor: ->
    # Grab jQuery, we're going to need it
    @$ = $

    #Grab URIjs, we're going to need it
    @urijs = urijs

    # Grab lodash, we're going to need it
    @_ = _

    # Initialize the map of FSMs. The map
    # will be hostnames as keys whose value
    # is a URI:FSM mapping.<br />E.G.
    # ``` javascript
    # {
    #   "github.com" : {
    #     "/api/users" : <Finite State Machine>,
    #     ...
    #   },
    #   ...
    # }```
    @FSMs = {}

    # Set the default for configurations.
    # This can be changed on a hostname, or
    # even a URI granularity as necessary.
    @configuration = new Configuration()


  # Configure
  # -----------
  # ___Set the configuration for all state machines to inherit___
  configure: (newConfig) ->
    @configuration.update(newConfig)


  # Ajax
  # -----------
  # ___Run an AJAX request after checking the state machine___
  # Parameters:
  # _url_: This is optional and can alternatively be specified in the __settings__ parameter
  # __settings__: An object that will be passed to $.ajax (http://api.jquery.com/jquery.ajax/#jQuery-ajax-settings)
  # _config_: The is an optional parameter and is used to set the configuration for this specific endpoint
  ajax: ->
    # Get the state machine based on the URI of the
    # request
    stateMachine = @getFsmFromUrl(@getUrl(arguments), @getConfig(arguments))

    # get the AJAX arguments
    ajaxArgs = @getAjaxArgs arguments

    # Check if the state is okay to send
    if stateMachine.isOk()
      # Get the successful callback function
      succFunc = ajaxArgs.success

      # Get the error callback function
      failFunc = ajaxArgs.error

      # Set the success callback to first log the successful request
      ajaxArgs.success = (data, status, jqXHR) ->
        stateMachine.successfulCall()
        succFunc.call data, status, jqXHR

      # Set the error callback to first log the failed request
      ajaxArgs.error = (jqXHR, status, err) ->
        stateMachine.failedCall status
        failFunc.call jqXHR, status, err

      # Pass the arguments to `$.ajax`
      @$.ajax ajaxArgs
    else
      # Alert the user that the request was not sent
      console.info 'Request not sent due to poor server state'


  # getFsmFromUrl
  # -----------
  # ___Get the FSM based on the url___<br />
  # The url will always be in this format:
  # ```javascript
  # {
  #   hostname: <string>,
  #   path: <string>
  # }
  # ```
  getFsmFromUrl: (url, config) ->
    # Get the URI:FSM map for the hostname
    hostUris = @FSMs[url.hostname]

    # Check if no config was passed
    if !config
      # Make config the default that was set
      config = @configuration.getAttributes()

    # create the configuration for the FSM
    configuration = new Configuration(config)

    # Check if the map exists
    if hostUris == undefined

      # Create a new map with a single
      # URI:FSM mapping
      @FSMs[url.hostname] = {}
      @FSMs[url.hostname][path] = new FiniteStateMachine(configuration)
    else

      # Check if the URI:FSM mapping exists
      if @FSMs[url.hostname][url.path] == undefined

        # Create a new URI:FSM mapping
        @FSMs[url.hostname][url.path] = new FiniteStateMachine(configuration)

    # Return the URI:FSM mapping
    @FSMs[url.hostname][url.path]


  # getUrl
  # -----------
  # ___Get the url from the AJAX  params___
  getUrl: (args) ->
    # Check if url was the first argument
    if args.length > 1 and typeof args[0] == "string"
      # Parse the url and pick the keys
       @_.pick(@urijs.parse(args[0]), ['hostname', 'path'])
    # Check that the url is in the "settings" parameter
    else if !!args[0].url
      # Parse the url and pick the keys
       @_.pick(@urijs.parse(args[0].url), ['hostname', 'path'])
    else
      # Just return an empty object
      {}


  # getConfig
  # -----------
  # ___Get the config from the AJAX  params___
  getConfig: (args) ->
    # Check if it was passed as the third argument
    if args.length == 3 and typeof args[2] == "object"
      args[2]
    # Check if it was passed as the second argument
    else if args.length == 2 and typeof args[1] == "object"
      args[1]
    # Just return the default
    else
      @configuration.getAttributes()

  # getAjaxArgs
  # -----------
  # ___Get the AJAX  params from an arguments list___
  getAjaxArgs: (args) ->
    # Check if the url was the first argument
    if args.length > 1 and typeof args[0] == "string"
      # Put the url in the params
      args[1].url = args[0]

      # Return the second (required) parameter
      args[1]
    else
      # If not, it must be in the first argument
      args[0]


window.cb = new CircuitBreaker
module.exports = CircuitBreaker
