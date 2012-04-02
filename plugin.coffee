stylus = require 'stylus'
path = require 'path'
async = require 'async'
fs = require 'fs'

module.exports = (wintersmith, callback) ->

  class StylusPlugin extends wintersmith.ContentPlugin

    constructor: (@_filename, @_base, @_text) ->

    getFilename: ->
      @_filename.replace /styl$/, 'css'

    render: (locals, contents, templates, callback) ->
      try
        stylus(@_text).set('filename', this.getFilename()).render (err, css) ->
          if err
            callback err
          else
            callback null, new Buffer css
      catch error
        callback error

  StylusPlugin.fromFile = (filename, base, callback) ->
    fs.readFile path.join(base, filename), (error, buffer) ->
      if error
        callback error
      else
        callback null, new StylusPlugin filename, base, buffer.toString()

  wintersmith.registerContentPlugin 'styles', '**/*.styl', StylusPlugin
  callback()
