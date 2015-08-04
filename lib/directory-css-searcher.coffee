{File} = require 'atom'
module.exports =
class DirectoryCSSSearcher

  constructor: ->
    @searchResults = []
    @file = null
    @matchStartLine = null

  supportedFileExtensions: [
      "*.css"
      "*.scss"
      "*.less"
  ]

  clear: ->
    @searchResults = []
    @file = null
    @matchStartLine = null

  findFilesThatContain:(selector) ->
    re = selector + '\\s*\\{'
    id_reg = new RegExp(re)
    atom.workspace.scan id_reg, {paths: @supportedFileExtensions}, @matchCallback.bind(@)
    .then () =>
      return unless @searchResults.length
      filePath = @searchResults[0].filePath
      @matchStartLine = @searchResults[0].matches[0].range[0][0]
      @file = new File filePath, false


  matchCallback: (match) ->
    @searchResults.push(match)

  getSelectorText: () ->
    if @file
      @file.read().then (content) =>
        lineNumber = 0
        text = ""
        for ch in content
          if lineNumber >= @matchStartLine
            text += ch
            if ch is "{"
              if not openBraces? then openBraces = 1 else openBraces++
            if ch is "}" and openBraces
              openBraces--
              break if openBraces is 0
          lineNumber++ if ch is "\n" or ch is "\r\n"
        return [true,
                {text: text,
                start: @matchStartLine,
                end: lineNumber,
                file: @file}]
    else
      return new Promise (resolve, reject) ->
        resolve([false, {text: null, start: null, end: null, file: null}])
