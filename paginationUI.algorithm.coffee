template =
  open: ->
    '<ul class=\'pages-list\'><li class=\'li\'><a class=\'btn-navigation btn-navigation-page-prev\'><</a></li>'
  close: ->
    '<li class=\'li\'><a class=\'btn-navigation btn-navigation-page-next\'>></a></li></ul>'
  item: (page, current) ->
    if page == current
      '<li class=\'li\'><a class=\'current btn-navigation btn-navigation-page-' + parseInt(page, 10) + 1 + '\' ><strong>' + parseInt(page, 10) + 1 + '</strong></a></li>'
    else
      '<li class=\'li\'><a class=\'btn-navigation btn-navigation-page-' + parseInt(page, 10) + 1 + '\' >' + parseInt(page, 10) + 1 + '</a></li>'

inherits = (object) ->
  from = (objectsArray) ->
    i = 0
    length = objectsArray.length

    while i < length
      for method of objectsArray[i].prototype
        if objectsArray[i]::hasOwnProperty(method)
          object.prototype[method] = objectsArray[i].prototype[method]
      i += 1
    return

  { from : from }

UI = (name) ->
  @name = name
  @memory = []
  @parentNode = []
  return

UI::markup = (markup) ->
  @html = markup
  return

UI::insert = (element) ->
  string = element or @html
  parser = new DOMParser()
  node = parser.parseFromString(string, 'text/html').getElementsByTagName('body')[0].childNodes[0]
  self = this

  {
    in : (parentNode) ->
      if parentNode != null
        parentNode.appendChild node
        self.memory.push node
        self.parentNode.push parentNode
      return
  }

UI::refresh = (element) ->
  string = element or @html
  parser = new DOMParser()
  node = parser.parseFromString(string, 'text/html').getElementsByTagName('body')[0].childNodes[0]
  self = this
  if @parentNode.length
    @parentNode[@parentNode.length - 1].innerHTML = @parentNode[@parentNode.length - 1].innerHTML.replace(@memory[@memory.length - 1].outerHTML, '')
    if element != null
      {
        in : (parentNode) ->
          if parentNode != null
            parentNode.appendChild node
            self.memory.push node
            self.parentNode.push parentNode
          return
      }
  else if element != null
    @insert(element)


PaginationUI = (numberOfPages) ->
  @length = numberOfPages - 1
  @memory = []
  @parentNode = []
  @current = 0
  @displayLimit = if numberOfPages > 12 then 12 else numberOfPages
  @loop = true


inherits(PaginationUI).from [Pagination, UI]

PaginationUI::build = (template) ->
  if @length > 0
    output = template.open()
    list = @display()
    i = 0
    while i < list.length
      output += template.item(list[i], @getCurrent())
      i += 1
    output += template.close()
    @html = output
    output

PaginationUI::render = (template) ->
  if @length > 0
    self = this
    common =
      page: (page) ->
        if page == 'next'
          self.next()
        else if page == 'previous'
          self.previous()
        else
          self.pick page
        common
      in: (target) ->
        self.refresh(self.build(template)).in target

    common


exports(PaginationUI).as("PaginationUI")
