wintersmith = require 'wintersmith'
{Config} = require 'wintersmith/src/core/config'
wsStylus = require './../'

# new wintersmith environment
env = wintersmith new Config, __dirname
env.config.stylus ?= {}
env.config.stylus.dependencies = ['nib']

describe "Nib integration", ->

  beforeEach (done)->
    # Install this plugin onto wintersmith
    wsStylus env, done

  it "should compile stylus with nib", (done)->

    # Parse contents
    env.ContentTree.fromDirectory env, 'test/contents/css', (err, tree)->

      # For style.styl, we want to make sure styl is compiling using nib
      tree['style.styl'].getView() env, null, null, null, (err, content)->

        if content?
          content.toString().should.equal("""
          body {
            -webkit-box-shadow: 0 0 1px #000;
            box-shadow: 0 0 1px #000;
          }

          """)
        else
          throw err

        do done
