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
  configure: (new_config) ->
    @configuration.update(new_config)


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
    state_machine = @get_fsm_from_url(@get_url(arguments), @get_config(arguments))

    # Check if the state is okay to send
    if state_machine.is_ok()
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
  #   path: <string>
  # }
  # ```
  get_fsm_from_url: (url, config) ->
    # Get the URI:FSM map for the hostname
    host_uris = @FSMs[url.hostname]

    # Check if no config was passed
    if !config
      # Make config the default that was set
      config = @configuration.get_attributes()

    # create the configuration for the FSM
    configuration = new Configuration(config)

    # Check if the map exists
    if host_uris == undefined

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


  # Get_url
  # -----------
  # ___Get the url from the AJAX  params___
  get_url: (args) ->
    # Check if url was the first argument
    if args.length == 3 and typeof args[0] == "string"
      # Parse the url and pick the keys
       @_.pick(@urijs.parse(args[0]), ['hostname', 'path'])
    # Check that the url is in the "settings" parameter
    else if !!args[0].url
      # Parse the url and pick the keys
       @_.pick(@urijs.parse(args[0].url), ['hostname', 'path'])
    else
      # Just return an empty object
      {}


  # Get_config
  # -----------
  # ___Get the config from the AJAX  params___
  get_config: (args) ->
    # Check if it was passed as the third argument
    if args.length == 3 and typeof args[2] == "object"
      args[2]
    # Check if it was passed as the second argument
    else if args.length == 2 and typeof args[1] == "object"
      args[1]
    # Just return the default
    else
      @configuration.get_attributes()


window.cb = new CircuitBreaker
module.exports = CircuitBreaker
