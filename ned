#!/usr/bin/env node

/**
 * ned
 * use javascript to manipulate stdin
 *
 * Licensed under MIT license.
 * Copyright (C) 2017 Karim Alibhai.
 */

'use strict'

var mapStream = require('map-stream')
  , split = require('split')
  , reduce = require('stream-reduce')
  , sort = require('sort-stream')
  , through = require('through')
  , argv = require('minimist')(process.argv.slice(2), {
      boolean: [
        'filter',  'f',
        'sort',    's',

        'trim',    't',
        'single',  'c',
        'numeric', 'n',

        'version', 'v',
        'help',    'h',
      ],

      string: [
        'reduce', 'r',

        'delim',  'd',
        'join',   'j'
      ]
    })
  , help = function () {
      console.log('usage: ned [options] [function]')
      console.log('use javascript to manipulate stdin')
      console.log('')
      console.log('  Types of manipulation:')
      console.log('    --filter, -f            Filter the input with [function]')
      console.log('    --reduce, -r [initial]  Reduce the input with [function]')
      console.log('    --sort, -s              Sort using [function] for comparisons')
      console.log('  ')
      console.log('  Or leave out these flags to map over the input.')
      console.log('  ')
      console.log('  General options:')
      console.log('    --trim, -t              Trim all data from stdin')
      console.log('    --single, -c            Replace all multiple spaces with a single space')
      console.log('    --delim, -d [delim]     Choose a delimeter to split by')
      console.log('    --join, -j [delim]      Choose a delimeter to join by (after processing)')
      console.log('    --numeric, -n           Treat all incoming data as numeric')
      console.log('    --version, -v           Output the version number')
      console.log('    --help, -h              Output help information')

      process.exit((argv.help || argv.h) ? 0 : -1)
    }

// output version
if (argv.version || argv.v) {
  console.log(require('./package').version)
  process.exit(0)
}

// only one argument is accepted, the function as a string
if (argv._.length !== 1 || argv.help || argv.h) help()

// pull function from string
var map = eval('(' + argv._[0] + ')')

// setup stream
process.stdout.setEncoding('utf8')
process.stdin.setEncoding('utf8')
process.stdin.resume()

/**
 * Process data based upon argv.
 */
function clean(data) {
  // clean data, if needed
  if (argv.trim || argv.t) data = data.trim()

  // max single-spaced
  if (argv.single || argv.c) data = data.replace(/\s+/g, ' ')

  // drop empty things
  if (!data) data = undefined

  // return the final data
  return (argv.numeric || argv.n) ? parseFloat(data) : data
}

/**
 * Transform helpers.
 */
var functions = {
  'map': function (fn) {
    return mapStream(function (data, next) {
      var ret = fn(data, next)
      if (ret !== undefined) next(null, ret)
    })
  }
, 'reduce': function (fn) {
    return reduce(function (a, b) {
      var ret = String(fn(a, b))
      return (argv.numeric || argv.n) ? parseFloat(ret) : ret
    }, 'reduce' in argv ? argv.reduce : argv.r)
  }
, 'filter': function (fn) {
    return mapStream(function (data, next) {
      // async handling
      var ret = fn(data, function (err, value) {
        if (err) throw err

        if (value) next(null, data)
        else next()
      })

      // sync handling
      if (ret !== undefined) {
        if (ret) next(null, data)
        else next()
      }
    })
  }
, sort: function (fn) {
    return sort(function (a, b) {
      return fn(a, b)
    })
  }
}, getFn = function (fn) {
  return (function () {
    if (argv.filter || argv.f) return functions.filter
    else if (argv.reduce || argv.r) return functions.reduce
    else if (argv.sort || argv.s) return functions.sort
    return functions.map
  }())(fn)
}

// figure out delimeters
var delim = new RegExp(argv.delim || argv.d || '\\r?\\n')
  , joiner = eval('("' + (argv.join || argv.j || '') + '")')

// start streaming
process.stdin
  .pipe(split(delim))
  .pipe(mapStream(function (data, next) { next(null, clean(String(data))) }))
  .pipe(getFn(map))
  .pipe(mapStream(function (data, next) { next(null, String(data)) }))

  // handle joining (refactored from event-stream)
  .pipe(through(function (data) {
    if (this.notFirst) {
      this.emit('data', joiner)
    }

    this.notFirst = true
    this.emit('data', data)
    return true
  }))
  .pipe(process.stdout)