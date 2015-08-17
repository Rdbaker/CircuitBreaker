'use strict'

$ = require('jquery')
_ = require('lodash')

class CircuitBreaker
  # Constructor
  # -----------
  constructor: ->
    # Grab jQuery, we're going to need it
    @$ = $
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
    # even a URI level as necessary.
    @configuration =
      # How long should the `Closed -> Partially Open`
      # timeout be (ms)?
      timeout: 10000
      # After how many successful requests should the
      # `Partially Open -> Open` state transition occur?
      resetAfter: 3
      # What is the threshold for failed requests for the
      # `Open -> Closed` state transition? This tolerance is
      # lowered for the `Partially Open -> Closed` transition.
      threshold: 2
      # Which errant status codes should be ignored in
      # reponses? This must be an array containing either
      # strings and/or integers. As a string, the regex wildcard
      # can be used to indicate statuses falling under
      # any match for those codes.<br />E.G. `"40."` means that
      # `[400, 401, 402, ... 409]` should be ignored
      ignoreCodes: ['4..']
      # This flag increases the verbosity so the user has more
      # transparency into what is going on behind the scenes
      debug: false

  # Configure
  # -----------
  # ___Set the configuration for all state machines to inherit___
  configure: (new_config) ->
    # Keep track of the previous configuration
    old_config = @configuration
    # Inherit the values of the new configuration
    @_.assign @configuration, new_config
    # Make sure that the new configuration is valid
    @validate_configuration old_config

  # Validate_configuration
  # ----------------------
  # ___Make sure the set configuration is proper___<br />
  # In any case, if the configuration is not acceptable,
  # then revert the new value to the previous value
  validate_configuration: (old_config) ->
    # Check that `@configuration.timeout` is
    # a number and is greater than 0
    if !(typeof @configuration.timeout) == "number" or !@configuration.timeout < 1
      if old_config.debug
        console.info '[validate_configuration]: Assignment of configuration.timeout failed.'
      @configuration.timeout = old_config.timeout
    # Check that `@configuration.resetAfter` is
    # a number and is greater than or equal to 0
    if !(typeof @configuration.resetAfter) == "number" or !@configuration.resetAfter < 0
      if old_config.debug
        console.info '[validate_configuration]: Assignment of configuration.resetAfter failed.'
      @configuration.resetAfter = old_config.resetAfter
    # Check that `@configuration.threshold` is
    # a number and is greater than 0
    if !(typeof @configuration.threshold) == "number" or !@configuration.threshold < 1
      if old_config.debug
        console.info '[validate_configuration]: Assignment of configuration.threshold failed.'
      @configuration.threshold = old_config.threshold
    # Check that `@configuration.ignoreCodes` is
    # an array and follows the spec for what we're expecting
    if !(@configuration.ignoreCodes instanceof Array) or !_.every(@configuration.ignoreCodes, @proper_code)
      if old_config.debug
        console.info '[validate_configuration]: Assignment of configuration.ignoreCodes failed.'
      @configuration.ignoreCodes = old_config.ignoreCodes

  # Proper_code
  # -----------
  # ___Decides if a given code is acceptable for our uses___
  proper_code: (code) ->
    # Define our regex rule for acceptable codes
    re = new RegExp(/[1-5][0-9\.][0-9\.]/)
    re.test(String(code))

  # Ajax
  # -----------
  # ___Run an AJAX request after checking the state machine___
  ajax: ->
    # Get the state machine based on the URI of the
    # request
    state_machine = @get_fsm_from_url(@get_url(arguments))
    # Check if the state is okay to send
    if state_machine.is_ok
      # TODO
      # >> Change the ajax callbacks to first be logged
      # >> to the correct FSM
      # Pass the arguments to `$.ajax`
      $.ajax arguments
    else
      # Alert the user that the request was not sent
      console.info 'Request not sent due to poor server state'

  # Get_fsm_from_url
  # -----------
  # ___Get the FSM based on the url___<br />
  # The url will always be in this format:
  # ```javascript
  # {
  #   hostname: <string>,
  #   uri: <string>
  # }
  # ```
  get_fsm_from_url: (url) ->
    # Get the URI:FSM map for the hostname
    host_uris = @FSMs[url.hostname]
    # Check if the map exists
    if host_uris == undefined
      # Get the URI we're going to hit
      uri = url.uri
      # Create a new map with a single
      # URI:FSM mapping
      @FSMs[url.hostname] =
        uri: new FiniteStateMachine(@configuration)
    else
      # Check if the URI:FSM mapping exists
      if @FSMs[url.hostname][url.uri] == undefined
        # Create a new URI:FSM mapping
        @FSMs[url.hostname][url.uri] = new FiniteStateMachine(@configuration)
    # Return the URI:FSM mapping
    @FSMs[url.hostname][url.uri]

  get_url: (args) ->
    console.log 'getting uri from', args

window.cb = new CircuitBreaker
module.exports = CircuitBreaker
