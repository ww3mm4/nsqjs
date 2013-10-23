should = require('chai').should()
decimal = require 'bignumber.js'
BackoffTimer = require '../lib/backofftimer'

describe 'backofftimer', ->
  timer = null
  beforeEach ->
    timer = new BackoffTimer 0, 128
  describe 'constructor', ->
    it 'should have @maxShortTimer eq 1', ->
      timer.maxShortTimer.toString().should.equal '32'
    it 'should have a @maxLongTimer eq 3', ->
      timer.maxLongTimer.toString().should.equal '96'
    it 'should have a @shortUnit equal to 0.1', ->
      timer.shortUnit.toString().should.equal '3.2'
    it 'should have a @longUnit equal to 0.3', ->
      timer.longUnit.toString().should.equal '0.384'

  describe 'success', ->
    it 'should adjust @shortInterval to 0', ->
      timer.success()
      timer.shortInterval.toString().should.equal '0'
    it 'should adjust @longInterval to 0', ->
      timer.success()
      timer.longInterval.toString().should.equal '0'

  describe 'failure', ->
    it 'should adjust @shortInterval to 3.2 after 1 failure', ->
      timer.failure()
      timer.shortInterval.toString().should.equal '3.2'
    it 'should adjust @longInterval to .384 after 1 failure', ->
      timer.failure()
      timer.longInterval.toString().should.equal '0.384'

  describe 'getInterval', ->
    it 'should initially be 0', ->
      timer.getInterval().toString().should.equal '0'
    it 'should be 0 after 1 success', ->
      timer.success()
      timer.getInterval().toString().should.equal '0'
    it 'should be 0 after 2 successes', ->
      timer.success()
      timer.success()
      timer.getInterval().toString().should.equal '0'
    it 'should be 3.584 after 1 failure', ->
      timer.failure()
      timer.getInterval().toString().should.equal '3.584'
    it 'should be 7.168 after 2 failure', ->
      timer.failure()
      timer.failure()
      timer.getInterval().toString().should.equal '7.168'
