App.EditCodemarkParentView = App.ModalView.extend
  initialize: ->
    @view = new App["#{@model.get('resource_type')}FormView"]
      model: @model
    @bindToView()

  render: ->
    @view.render()
    @$el.html(@view.el)
    if @options.modal
      @openAsModal()

  bindToView: ->
    @view.bind('cancel', => @close())
    @view.bind('cancel', => @trigger('cancel'))
