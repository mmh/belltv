class Dashing.Mailq extends Dashing.Widget
  @accessor 'current', Dashing.AnimatedValue
  @accessor 'currentsmtp', Dashing.AnimatedValue
  @accessor 'currentsmtp2', Dashing.AnimatedValue
  @accessor 'currentsmtp3', Dashing.AnimatedValue

# mail
  @accessor 'difference', ->
    if @get('last')
      last = parseInt(@get('last'))
      current = parseInt(@get('current'))
      if last != 0
        diff = Math.abs(Math.round((current - last) / last * 100))
        "#{diff}%"
    else
      ""

# smtp
  @accessor 'differencesmtp', ->
    if @get('lastsmtp')
      lastsmtp = parseInt(@get('lastsmtp'))
      currentsmtp = parseInt(@get('currentsmtp'))
      if lastsmtp != 0
        diff = Math.abs(Math.round((currentsmtp - lastsmtp) / lastsmtp * 100))
        "#{diff}%"
    else
      ""

# smtp2
  @accessor 'differencesmtp2', ->
    if @get('lastsmtp2')
      lastsmtp2 = parseInt(@get('lastsmtp2'))
      currentsmtp2 = parseInt(@get('currentsmtp2'))
      if lastsmtp2 != 0
        diff = Math.abs(Math.round((currentsmtp2 - lastsmtp2) / lastsmtp2 * 100))
        "#{diff}%"
    else
      ""

# smtp3
  @accessor 'differencesmtp3', ->
    if @get('lastsmtp3')
      lastsmtp3 = parseInt(@get('lastsmtp3'))
      currentsmtp3 = parseInt(@get('currentsmtp3'))
      if lastsmtp3 != 0
        diff = Math.abs(Math.round((currentsmtp3 - lastsmtp3) / lastsmtp3 * 100))
        "#{diff}%"
    else
      ""

# mail
  @accessor 'arrow', ->
    arrow_direction = 'none'
    if @get('last')
      if parseInt(@get('current')) > parseInt(@get('last'))
        arrow_direction ='up' 
      else if parseInt(@get('current')) < parseInt(@get('last'))
        arrow_direction = 'down'
    return 'icon-arrow-' + arrow_direction 

# smtp
  @accessor 'arrowsmtp', ->
    arrow_direction = 'none'
    if @get('lastsmtp')
      if parseInt(@get('currentsmtp')) > parseInt(@get('lastsmtp'))
        arrow_direction ='up' 
      else if parseInt(@get('currentsmtp')) < parseInt(@get('lastsmtp'))
        arrow_direction = 'down'
    return 'icon-arrow-' + arrow_direction 

# smtp2
  @accessor 'arrowsmtp2', ->
    arrow_direction = 'none'
    if @get('lastsmtp2')
      if parseInt(@get('currentsmtp2')) > parseInt(@get('lastsmtp2'))
        arrow_direction ='up' 
      else if parseInt(@get('currentsmtp2')) < parseInt(@get('lastsmtp2'))
        arrow_direction = 'down'
    return 'icon-arrow-' + arrow_direction 

# smtp3
  @accessor 'arrowsmtp3', ->
    arrow_direction = 'none'
    if @get('lastsmtp3')
      if parseInt(@get('currentsmtp3')) > parseInt(@get('lastsmtp3'))
        arrow_direction ='up' 
      else if parseInt(@get('currentsmtp3')) < parseInt(@get('lastsmtp3'))
        arrow_direction = 'down'
    return 'icon-arrow-' + arrow_direction 

  onData: (data) ->
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    # $(@node).fadeOut().fadeIn()
    if data.status
      # clear existing "status-*" classes
      $(@get('node')).attr 'class', (i,c) ->
        c.replace /\bstatus-\S+/g, ''
      # add new class
      $(@get('node')).addClass "status-#{data.status}"

