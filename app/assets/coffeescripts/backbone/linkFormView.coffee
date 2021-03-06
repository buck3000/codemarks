App.LinkFormView = App.CodemarkFormView.extend
  fetchFullFormFor: (url) ->
    data = { url: url }
    $.ajax
      type: 'GET'
      url: '/codemarks/new'
      data: { url: url }
      success: (response) =>
        if response.resource_type == "Link"
          existingModel = App.codemarks?.where({ id: response.id })[0]
          @model = existingModel || new App.Codemark(response)
          @render()
        else
          @trigger('rerender', new App.Codemark(response))
      error: (response) =>
        setFlash('error', 'Sorry, but something went wrong. <br/> <a href="https://codemarks.uservoice.com/" target="_blank">Tell us what happened</a> or, even better, <a href="https://github.com/gmassanek/codemarks" target="_blank">fix it here</a>!')
        @cancel()

  presentedAttributes: ->
    url: @model.get('resource').url
    title: @model.get('title') || ''
    description: @model.get('description') || ''
    topics: @presentedTopics()
