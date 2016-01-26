Pagination = (numberOfPages) ->
  @length = numberOfPages - 1
  @current = 0
  @displayLimit = if numberOfPages > 12 then 12 else numberOfPages
  @loop = true
  return

Pagination::setDisplayLimit = (int) ->
  @displayLimit = if int > 2 and int < @length + 1 then int else @displayLimit
  return

Pagination::getCurrent = ->
  @current

Pagination::first = ->
  @current = 0
  @current

Pagination::last = ->
  @current = @length
  @current

Pagination::next = ->
  if @loop
    if @current + 1 <= @length then (@current += 1) else @first()
  else
    if @current + 1 <= @length then (@current += 1) else @current

Pagination::previous = ->
  if @loop
    if @current - 1 >= 0 then (@current -= 1) else @last()
  else
    if @current - 1 >= 0 then (@current -= 1) else @current

Pagination::pick = (pageNumber) ->
  if pageNumber - 1 <= @length and pageNumber - 1 >= 0
    @current = pageNumber - 1
  @current

Pagination::display = ->
  if @length > 0
    list = undefined
    i = undefined
    j = undefined
    half = undefined
    list = []
    half = Math.floor(@displayLimit / 2)
    if @length <= @displayLimit
      i = 0
      while i < @displayLimit
        list.push i
        i += 1
    else
      if @current > half and @current < @length - half
        # populate array until half of the display limit counting back from this.current value
        i = half + 1
        j = 0
        while i > 0
          list[i - 1] = @current - j
          i -= 1
          j += 1
        # fill in the rest of the array with values counting from the last in array
        if !(@displayLimit % 2)
          i = 0
          while i < half
            list[half + i] = list[half] + i
            i += 1
        else
          i = 0
          while i <= half
            list[half + i] = list[half] + i
            i += 1
      else if @current > half and @current >= @length - half
        i = @displayLimit - 1
        j = 0
        while i >= 0
          list[i] = @length - j
          i -= 1
          j += 1
      else
        i = 0
        while i < @displayLimit
          list[i] = i
          i += 1
    return list
  return

exports(Pagination).as("Pagination")