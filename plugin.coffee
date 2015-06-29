stylus = require 'stylus'
nib    = require 'nib'
path = require 'path'
fs = require 'fs'

module.exports = (env, callback) ->

  class StylusPlugin extends env.ContentPlugin

    constructor: (@_filepath, @_text) ->

    getFilename: ->
      @_filepath.relative.replace /styl$/, 'css'

    getView: ->
      return (env, locals, contents, templates, callback) =>

        try
          options = env.config.stylus or {}
          options.filename = @getFilename()
          options.paths = [path.dirname(@_filepath.full)]

          renderer = stylus(@_text, options)

          # allowing to specify dependencies (including nib) via config file
          #
          #  "stylus": {
          #   "dependencies": [
          #     "nib",
          #     "jeet"
          #   ]
          # }
          dependencies = options.dependencies

          if dependencies?
            for dependency in dependencies
              currentLib = require(dependency)
              renderer.use(currentLib()) if currentLib?

          renderer.render (err, css) ->
            if err
              callback err
            else
              callback null, new Buffer css
        catch error
          callback error

  StylusPlugin.fromFile = (filepath, callback) ->
    fs.readFile filepath.full, (error, buffer) ->
      if error
        callback error
      else
        callback null, new StylusPlugin(filepath, buffer.toString())

  env.registerContentPlugin 'styles', '**/*.styl', StylusPlugin
  do callback
