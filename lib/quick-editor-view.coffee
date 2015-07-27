{Point, Range} = require 'atom'
module.exports =
class QuickEditorView
  constructor: ->
    [@file, @text, @editRange] = []

    @element = document.createElement 'div'
    @element.classList.add 'quick-editor'

    @textEditorView = document.createElement 'atom-text-editor'
    @textEditor = @textEditorView.getModel()

    @grammarReg = atom.grammars

    @element.appendChild @textEditorView

  destroy: ->
    @textEditor = null
    @element.remove()

  getElement: ->
    @element

  save: ->
    @file.read().then (content) =>
      modifyingTextEditor = document.createElement('atom-text-editor').getModel()
      modifyingTextEditor.getBuffer().setPath @file.getPath()
      modifyingTextEditor.setText content

      modifiedSelector = @textEditor.getText()
      modifyingTextEditor.setTextInBufferRange(@editRange, modifiedSelector)
      modifyingTextEditor.save()

  setFile: (file) ->
    @file = file

  setText: (text) ->
    @text = text

  setup: (text, start, end, file) ->
    @setText(text)
    @setFile(file)

    grammar = @grammarReg.selectGrammar @file.getPath(), @text
    @textEditor.setGrammar grammar
    @textEditor.setText @text

    @editRange = new Range(new Point(start, 0), new Point(end, Infinity))

  open: () ->
    throw new Error "Must choose a file to quick-edit" if @file is null

    lineHeight = atom.workspace.getActiveTextEditor().getLineHeightInPixels()
    numLines = @editRange.end.row - @editRange.start.row + 1
    @element.style.height = (lineHeight * numLines) + "px"
