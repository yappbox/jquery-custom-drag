(($)->
  abs = Math.abs
  supportsTouch = 'ontouchstart' of window
  events = if supportsTouch
    start: 'touchstart'
    move: 'touchmove'
    end: 'touchend touchcancel'
  else
    start: 'mousedown'
    move: 'mousemove'
    end: 'mouseup mouseleave'

  dragTarget = null
  startPos = null

  getPos = (event)->
    source = event.originalEvent || event
    source = if source.touches && source.touches.length then source.touches[ 0 ] else source
    pageX: source.pageX
    pageY: source.pageY

  buildEvent = (eventName, originalEvent)->
    event = $.Event(eventName)
    event.originalEvent = event
    pos = getPos(originalEvent)
    event.pageX = pos.pageX
    event.pageY = pos.pageY
    event

  checkThreshold = (pos)->
    abs(pos.pageX - startPos.pageX) > 4 || abs(pos.pageY - startPos.pageY) > 4

  handleMove = (event)->
    pos = getPos(event)
    unless dragTarget
      if checkThreshold(pos)
        customdragstart = buildEvent('customdragstart', event)
        $(event.target).trigger(customdragstart)
        dragTarget = customdragstart.dragTarget
        return handleEnd() unless dragTarget
    else
      $(dragTarget).trigger(buildEvent('customdragmove', event))
      event.preventDefault()
      return false
    return

  handleEnd = (event)->
    $(this).unbind(events.move, handleMove)
    $(this).unbind(events.end, handleEnd)
    target = dragTarget
    startPos = null
    dragTarget = null
    if target
      $(target).trigger(buildEvent('customdragend', event))
    return

  handleDown = (event)->
    startPos = getPos(event)
    dragTarget = null
    $(this).bind(events.move, handleMove)
    $(this).bind(events.end, handleEnd)
    return

  special = $.event.special
  special.customdragstart =
    setup: ->
      $(this).bind(events.start, handleDown)

  special.customdragmove = special.customdragend = {}
)(jQuery)
