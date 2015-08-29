'use strict'

class StateMachine
  # Constructor
  # -----------
  constructor: (@config) ->
    # Set the state to closed
    @state = 'closed'

    # Set the current threshold
    @threshold = @config.threshold

    # Set the current resetCount
    @resetCounter = 0


  # isOk
  # ----
  # ___Decide if it's okay to send a request in this state___
  isOk: ->
    # It's only okay if the circuit is closed or half closed
    @state == 'closed' or @state == 'half-closed'


  # successfulCall
  # --------------
  # ___What to do on a successful call___
  successfulCall: ->
    # Check that the circuit isn't closed
    if !@isOk()
      # Check that the reset counter is at the resetAfter mark
      if ++@resetCounter >= @config.resetAfter
        # Reset the counter
        @resetCounter = 0

        # Close the circuit
        @state = 'closed'


  # failedCall
  # ----------
  # ___What to do on a failed call___
  failedCall: (status) ->
    # check that the status code is not acceptable
    if !@config.isProperCode status
      # Reset the counter
      @resetCounter = 0

      # Check that the threshold is surpassed
      if ++@threshold >= @config.threshold
        # Pop the circuit
        @state = 'open'

        # Start the timer to close the circuit
        setTimeout @closeCircuit, @config.timeout


  # closeCircuit
  # ------------
  # ___Close the circuit after a timeout___
  closeCircuit: =>
    # change the circuit to half-closed
    @state = 'half-closed'


module.exports = StateMachine
