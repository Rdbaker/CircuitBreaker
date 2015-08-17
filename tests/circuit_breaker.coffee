'use strict'

CircuitBreaker = require('../dist/circuitbreaker')
_ = require('lodash')

describe 'CircuitBreaker', ->
  it 'is defined', ->
    expect(CircuitBreaker).toBeDefined()
    console.log cb

  describe 'The initial state', ->
    it 'has $ defined on it', ->
      expect(cb.$).toBeDefined()

    it 'has _ defined on it', ->
      expect(cb._).toBeDefined()

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

    it 'has "validate_configuration" defined on it', ->
      expect(cb.validate_configuration).toBeDefined()

    it 'has "proper_code" defined on it', ->
      expect(cb.proper_code).toBeDefined()

    it 'has "FSMs" defined on it', ->
      expect(cb.FSMs).toBeDefined()

    it 'only has 10 initial objects/functions', ->
      expect(Object.keys(cb).length + Object.keys(cb.__proto__).length).toBe 10
