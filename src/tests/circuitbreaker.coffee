'use strict'

CircuitBreaker = require('../circuitbreaker.coffee')
_ = require('lodash')


describe('CircuitBreaker', ->
  cb = new CircuitBreaker

  it 'is defined', ->
    expect(CircuitBreaker).toBeDefined()

  describe 'The initial state', ->
    it 'has $ defined on it', ->
      expect(cb.$).toBeDefined()

    it 'has _ defined on it', ->
      expect(cb._).toBeDefined()

    it 'has urijs defined on it', ->
      expect(cb.urijs).toBeDefined()

    it 'has "ajax" defined on it', ->
      expect(cb.ajax).toBeDefined()

    it 'has "configure" defined on it', ->
      expect(cb.configure).toBeDefined()

    it 'has "get_fsm_from_url" defined on it', ->
      expect(cb.get_fsm_from_url).toBeDefined()

    it 'has "get_url" defined on it', ->
      expect(cb.get_url).toBeDefined()

    it 'has "configuration" defined on it', ->
      expect(cb.configuration).toBeDefined()

    it 'has "get_config" defined on it', ->
      expect(cb.get_config).toBeDefined()

    it 'has "FSMs" defined on it', ->
      expect(cb.FSMs).toBeDefined()

    it 'only has 9 initial objects/functions', ->
      expect(Object.keys(cb).length + Object.keys(cb.__proto__).length).toBe 10
)
