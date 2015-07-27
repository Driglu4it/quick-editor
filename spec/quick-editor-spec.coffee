QuickEditor = require '../lib/quick-editor'
File = require 'atom'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "QuickEditor", ->
  [activationPromise, editor, editorView, workspaceView] = []

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()

    runs ->
      workspaceView = atom.views.getView atom.workspace
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView editor
      editor.setText "id=\"other-id\""
      editor.setCursorScreenPosition [0, 7]

      activationPromise = atom.packages.activatePackage 'quick-editor'

  activateAndThen = (callback) ->
    atom.commands.dispatch(editorView, 'quick-editor:quick-edit')
    waitsForPromise -> activationPromise
    runs(callback)

  describe "when a quick-editor:quick-edit event is triggered", ->
    it "should activate", ->
      activateAndThen ->
        expect(workspaceView.querySelector(".quick-editor")).toExist()

    it "should show a panel", ->
      activateAndThen ->
          quickEditorElement = workspaceView.querySelector ".quick-editor"
          quickEditorPanel = atom.workspace.panelForItem quickEditorElement

          expect(quickEditorPanel.isVisible()).toBe true #HERE
