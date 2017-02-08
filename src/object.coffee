_ = require('./util/lodash-wrap')
cloneWithNonEnumerableProperties = require('./util/clone-with-non-enumerable-properties')
isConstructor = require('./replace/is-constructor')
tdFunction = require('./function')

DEFAULT_OPTIONS = excludeMethods: ['then']

module.exports = (nameOrType, config) ->
  _.tap createTestDoubleObject(nameOrType, withDefaults(config)), (obj) ->
    obj.toString = -> description(nameOrType)

createTestDoubleObject = (nameOrType, config) ->
  if isConstructor(nameOrType)
    createTestDoublesForPrototype(nameOrType, config)
  else if _.isPlainObject(nameOrType)
    createTestDoublesForPlainObject(nameOrType, config)
  else if _.isArray(nameOrType)
    createTestDoublesForFunctionNames(nameOrType, config)
  else
    createTestDoubleViaProxy(nameOrType, config)

getAllPropertyNames = (type) ->
  props = []
  while true
    props = _.union(props, Object.getOwnPropertyNames(type))
    break unless type = Object.getPrototypeOf(type)
  props

createTestDoublesForPrototype = (type, config) ->
  _.reduce getAllPropertyNames(type.prototype), (memo, name) ->
    memo[name] = if _.isFunction(type.prototype[name])
      tdFunction("#{nameOf(type)}##{name}", config)
    else
      type.prototype[name]
    memo
  , {}

createTestDoublesForPlainObject = (obj, config) ->
  _.reduce _.functions(obj), (memo, functionName) ->
    memo[functionName] = if isConstructor(obj[functionName])
      createTestDoublesForPrototype(obj[functionName])
    else
      tdFunction(".#{functionName}", config)

    memo
  , cloneWithNonEnumerableProperties(obj)

createTestDoublesForFunctionNames = (names, config) ->
  _.reduce names, (memo, functionName) ->
    memo[functionName] = tdFunction(".#{functionName}", config)
    memo
  , {}

createTestDoubleViaProxy = (name, config) ->
  proxy = new Proxy obj = {},
    get: (target, propKey, receiver) ->
      if !obj.hasOwnProperty(propKey) && !_.includes(config.excludeMethods, propKey)
        obj[propKey] = proxy[propKey] = tdFunction("#{nameOf(name)}##{propKey}", config)
      obj[propKey]

withDefaults = (config) ->
  _.extend({}, DEFAULT_OPTIONS, config)

nameOf = (nameOrType) ->
  if _.isFunction(nameOrType) && nameOrType.name?
    nameOrType.name
  else if _.isString(nameOrType)
    nameOrType
  else
    ''

description = (nameOrType) ->
  name = nameOf(nameOrType)
  "[test double object#{if name then " for \"#{name}\"" else ''}]"
