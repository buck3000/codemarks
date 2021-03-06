App.Filters = Backbone.Model.extend
  loadFromCookie: (saved_filters) ->
    @attributes = @defaults()

    @setSort(saved_filters.by) if saved_filters.by
    @setUser(saved_filters.user) if saved_filters.user
    @setPage(saved_filters.page) if saved_filters.page
    @setGroup(saved_filters.group_id) if saved_filters.group_id
    @setSearchQuery(saved_filters.query) if saved_filters.query

    if saved_filters.topic_ids
      _.each saved_filters.topic_ids.split(','), (topicSlug) =>
        @addTopic(topicSlug)

  defaults: ->
    _.extend {},
      sort: 'date'
      currentPage: 1
      topics: {}

  reset: ->
    @attributes = @defaults()
    @set('currentPage', @defaults().currentPage)

  setSort: (sortType) ->
    @set('sort', sortType)

  setUser: (username) ->
    @set('user', username)

  hasUser: (username) ->
    @get('user') == username

  addUser: (username) ->
    @setUser(username)

  removeUser: ->
    @setUser(undefined)

  clearUsers: ->
    @removeUser()

  setGroup: (groupId) ->
    @set('group', groupId)

  removeGroup: (groupId) ->
    @setGroup(undefined)

  addTopic: (id) ->
    @get('topics')[id] = true
    @trigger('change')

  removeTopic: (id) ->
    delete @get('topics')[id]
    @trigger('change')

  topicIds: ->
    keys = []
    for key, _val of @get('topics')
      keys.push(key)
    keys

  clearTopics: ->
    @set('topics', @defaults().topics)

  topicId: ->
    for key, _val of @get('topics')
      return key

  hasTopic: (topic_id) ->
    $.inArray(topic_id, @topicIds()) >= 0

  setTopic: (topic) ->
    @clearTopics()
    @addTopic(topic)

  topicCount: ->
    Object.keys(@get('topics')).length

  setPage: (page) ->
    @set('currentPage', page)

  searchQuery: ->
    @get('query')

  setSearchQuery: (query) ->
    @set('query', query)

  clearSearchQuery: ->
    @unset('query')

  dataForTitle: ->
    title = ""
    if @get('user')
      title += "#{@get('user')}'s "
    if @get('query')
      title += @get('query') + " "
    if @topicCount() > 0
      title += @topicIds().join(", ") + " "
    if @get('currentPage') > 1
      title += " (#{@get('currentPage')})"
    if title == ""
      title = "Browse"
    title

  data: ->
    data = {}
    data['by'] = @get('sort') if @get('sort') != @defaults().sort
    data['user'] = @get('user') if @get('user')
    data['topic_ids'] = @topicIds().join() if @topicIds().length > 0
    data['group_id'] = @get('group') if @get('group')
    data['page'] = @get('currentPage') if @get('currentPage')? && @get('currentPage') != 1
    data['query'] = @searchQuery() if @searchQuery()
    data
