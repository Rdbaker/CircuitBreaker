'use strict'

_ = require('lodash')

class Configuration
  # Constructor
  # -----------
  constructor: (attrs) ->
    @_ = _

    # Set the default attributes
    @attributes = @default_attributes

    # Set the attrs that were given to us
    @update(attrs)


  # Constructor
  # -----------
  # ___Update the configuration's attributes___
  update: (attributes) ->
    # Keep track of the previous configuration
    old_attributes = @attributes

    # Inherit the values of the new configuration
    @_.assign @attributes, attributes

    # Make sure that the new configuration is valid
    @validate_configuration old_attributes


  # Default_attributes
  # ------------------
  # ___Define the default attributes___
  default_attributes:
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


  # Validate_configuration
  # ----------------------
  # ___Make sure the set configuration is proper___<br />
  # In any case, if the configuration is not acceptable,
  # then revert the new value to the previous value
  validate_configuration: (old_attributes) ->
    # Check that `@attributes.timeout` is
    # a number and is greater than 0
    if !(typeof @attributes.timeout) == "number" or !@attributes.timeout < 1
      if old_attributes.debug
        console.info '[validate_configuration]: Assignment of attributes.timeout failed.'
      @attributes.timeout = old_attributes.timeout

    # Check that `@attributes.resetAfter` is
    # a number and is greater than or equal to 0
    if !(typeof @attributes.resetAfter) == "number" or !@attributes.resetAfter < 0
      if old_attributes.debug
        console.info '[validate_configuration]: Assignment of attributes.resetAfter failed.'
      @attributes.resetAfter = old_attributes.resetAfter

    # Check that `@attributes.threshold` is
    # a number and is greater than 0
    if !(typeof @attributes.threshold) == "number" or !@attributes.threshold < 1
      if old_attributes.debug
        console.info '[validate_configuration]: Assignment of attributes.threshold failed.'
      @attributes.threshold = old_attributes.threshold

    # Check that `@attributes.ignoreCodes` is
    # an array and follows the spec for what we're expecting
    if !(@attributes.ignoreCodes instanceof Array) or !_.every(@attributes.ignoreCodes, @is_proper_code)
      if old_attributes.debug
        console.info '[validate_configuration]: Assignment of attributes.ignoreCodes failed.'
      @attributes.ignoreCodes = old_attributes.ignoreCodes


  # Is_proper_code
  # -----------
  # ___Decides if a given code is acceptable for our uses___
  is_proper_code: (code) ->
    # Define our regex rule for acceptable codes
    re = new RegExp(/[1-5][0-9\.][0-9\.]/)
    re.test(String(code))


  # Get_attributes
  # --------------
  # ___Return the attributes of the configuration___
  get_attributes: ->
    @attributes

module.exports = Configuration
