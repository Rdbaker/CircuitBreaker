'use strict'

_ = require('lodash')

class Configuration
  # Constructor
  # -----------
  constructor: (attrs) ->
    @_ = _

    # Set the default attributes
    @attributes = @defaultAttributes

    # Set the attrs that were given to us
    @update(attrs)


  # Constructor
  # -----------
  # ___Update the configuration's attributes___
  update: (attributes) ->
    # Keep track of the previous configuration
    oldAttributes = @attributes

    # Inherit the values of the new configuration
    @_.assign @attributes, attributes

    # Make sure that the new configuration is valid
    @validateConfiguration oldAttributes


  # defaultAttributes
  # ------------------
  # ___Define the default attributes___
  defaultAttributes:
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


  # validateConfiguration
  # ----------------------
  # ___Make sure the set configuration is proper___<br />
  # In any case, if the configuration is not acceptable,
  # then revert the new value to the previous value
  validateConfiguration: (oldAttributes) ->
    # Check that `@attributes.timeout` is
    # a number and is greater than 0
    if !(typeof @attributes.timeout) == "number" or !@attributes.timeout < 1
      if oldAttributes.debug
        console.info '[validate_configuration]: Assignment of attributes.timeout failed.'
      @attributes.timeout = oldAttributes.timeout

    # Check that `@attributes.resetAfter` is
    # a number and is greater than or equal to 0
    if !(typeof @attributes.resetAfter) == "number" or !@attributes.resetAfter < 0
      if oldAttributes.debug
        console.info '[validateConfiguration]: Assignment of attributes.resetAfter failed.'
      @attributes.resetAfter = oldAttributes.resetAfter

    # Check that `@attributes.threshold` is
    # a number and is greater than 0
    if !(typeof @attributes.threshold) == "number" or !@attributes.threshold < 1
      if oldAttributes.debug
        console.info '[validateConfiguration]: Assignment of attributes.threshold failed.'
      @attributes.threshold = oldAttributes.threshold

    # Check that `@attributes.ignoreCodes` is
    # an array and follows the spec for what we're expecting
    if !(@attributes.ignoreCodes instanceof Array) or !_.every(@attributes.ignoreCodes, @isProperCode)
      if oldAttributes.debug
        console.info '[validate_configuration]: Assignment of attributes.ignoreCodes failed.'
      @attributes.ignoreCodes = oldAttributes.ignoreCodes


  # isProperCode
  # -----------
  # ___Decides if a given code is acceptable for our uses___
  isProperCode: (code) ->
    # Define our regex rule for acceptable codes
    re = new RegExp(/[1-5][0-9\.][0-9\.]/)
    re.test(String(code))


  # getAttributes
  # --------------
  # ___Return the attributes of the configuration___
  getAttributes: ->
    @attributes

module.exports = Configuration
