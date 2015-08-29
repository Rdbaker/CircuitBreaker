'use strict'

CircuitBreaker = require('../circuitbreaker.coffee')
_ = require('lodash')


describe 'CircuitBreaker', ->
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

    it 'has "getFsmFromUrl" defined on it', ->
      expect(cb.getFsmFromUrl).toBeDefined()

    it 'has "getUrl" defined on it', ->
      expect(cb.getUrl).toBeDefined()

    it 'has "configuration" defined on it', ->
      expect(cb.configuration).toBeDefined()

    it 'has "getConfig" defined on it', ->
      expect(cb.getConfig).toBeDefined()

    it 'has "FSMs" defined on it', ->
      expect(cb.FSMs).toBeDefined()

    it 'has "getAjaxArgs" defined on it', ->
      expect(cb.getAjaxArgs).toBeDefined()

    it 'only has 11 initial objects/functions', ->
      expect(Object.keys(cb).length + Object.keys(cb.__proto__).length).toBe 11

  describe '#ajax', ->
    fsm = {}

    beforeEach ->
      fsm = jasmine.createSpyObj('fsm', ['isOk'])
      spyOn(cb.$, 'ajax')
      spyOn(cb, 'getUrl')
      spyOn(cb, 'getConfig')
      spyOn(cb, 'getAjaxArgs')
      spyOn(cb, 'getFsmFromUrl').and.returnValue(fsm)

    describe 'an "OK" FSM state', ->
      beforeEach ->
        fsm.isOk.and.returnValue true

      it 'calls @$.ajax with its arguments', ->
        args =
          url: 'testurl.com/test-path'
          method: 'GET'
        cb.getAjaxArgs.and.returnValue args

        cb.ajax args

        expect(fsm.isOk).toHaveBeenCalled()
        expect(cb.$.ajax).toHaveBeenCalledWith args

    describe 'a "Not-so-OK" FSM state', ->
      beforeEach ->
        fsm.isOk.and.returnValue false
        cb.$.ajax.calls.reset()

      it 'doesnt call @$.ajax', ->
        expect(cb.$.ajax).not.toHaveBeenCalled()
