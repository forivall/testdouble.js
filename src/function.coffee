_ = require('./util/lodash-wrap')

store = require('./store')
calls = require('./store/calls')
stubbings = require('./store/stubbings')

module.exports = (name, config) ->
  _.tap createTestDoubleFunction(config), (testDouble) ->
    entry = store.for(testDouble, true)
    if name?
      entry.name = name
      testDouble.toString = -> "[test double for \"#{name}\"]"
    else
      testDouble.toString = -> "[test double (unnamed)]"

createTestDoubleFunction = (config) ->
  testDouble = (args...) ->
    calls.log(testDouble, args, this)
    stubbings.invoke(testDouble, args)
  _.assign(testDouble, config)
  testDouble
