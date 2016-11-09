{ HotCodePush } = share

FlowRouterAutoscroll =
  animationDuration: 200
  marginTop: 0
  except: []

backToPosition = undefined
# Saved positions will survive a hot code push
scrollPositions = new ReactiveDict('okgrow-router-autoscroll')

# local variable for accessing jquery, if available
_jQuery = false
if Package['jquery']
  _jQuery = Package['jquery'].jQuery

#TODO use history state so we don't litter
window.onpopstate = ->
  backToPosition = scrollPositions.get(window.location.href)

saveScrollPosition = ->
  scrollPositions.set window.location.href, scrollTop()

# use _jQuery if available, otherwise support IE9+

scrollTop = ->
  if _jQuery
    _jQuery(window).scrollTop()
  else
    # uses solution from http://stackoverflow.com/questions/871399/cross-browser-method-for-detecting-the-scrolltop-of-the-browser-window
    document.body.scrollTop or document.documentElement.scrollTop or window.pageYOffset

scrollTo = (position) ->
  if _jQuery
    _jQuery('body,html').animate { scrollTop: position - (FlowRouterAutoscroll.marginTop) }, FlowRouterAutoscroll.animationDuration
  else
    window.scroll 0, position - (FlowRouterAutoscroll.marginTop)

# Scroll to the right place after changing routes. "The right place" is:
# 1. The previous position if we're returning via the back button
# 2. The element whose id is specified in the URL hash
# 3. The top of page otherwise

getScrollToPosition = ->
  if backToPosition
    oldPosition = backToPosition
    backToPosition = undefined
    return oldPosition
  id = window.location.hash.replace('#', '')
  element = document.getElementById(id)
  if element
    return element.getBoundingClientRect().top + scrollTop()
  else
    return 0

#Do the scroll, after the DOM update so that the position can be correct
scheduleScroll = ->
  Tracker.afterFlush ->
    Meteor.defer ->
      position = getScrollToPosition()
      scrollTo position

flowScroll = (newRoute) ->
  console.log 'running flowScroll'
  path = newRoute.context and newRoute.context.pathname or newRoute.path
  if path.indexOf('#') == -1
    scrollTo 0
  else
    scheduleScroll()

init = (options) ->
  if options
    for key, value of options
      FlowRouterAutoscroll[key] = value

  if Package['kadira:flow-router']
    Package['kadira:flow-router'].FlowRouter.triggers.enter [ flowScroll ], except: FlowRouterAutoscroll.except
    Package['kadira:flow-router'].FlowRouter.triggers.exit [ saveScrollPosition ]
  if Package['kadira:flow-router-ssr']
    Package['kadira:flow-router-ssr'].FlowRouter.triggers.enter [ flowScroll ], except: FlowRouterAutoscroll.except
    Package['kadira:flow-router-ssr'].FlowRouter.triggers.exit [ saveScrollPosition ]
  if Package['meteorhacks:flow-router']
    Package['meteorhacks:flow-router'].FlowRouter.triggers.enter [ flowScroll ], except: FlowRouterAutoscroll.except
    Package['meteorhacks:flow-router'].FlowRouter.triggers.exit [ saveScrollPosition ]
  if Package['meteorhacks:flow-router-ssr']
    Package['meteorhacks:flow-router-ssr'].FlowRouter.triggers.enter [ flowScroll ], except: FlowRouterAutoscroll.except
    Package['meteorhacks:flow-router-ssr'].FlowRouter.triggers.exit [ saveScrollPosition ]

HotCodePush.start.then ->
  currentScroll = scrollTop()
  scrollPositions.set 'HotCodePushScrollPosition', currentScroll

HotCodePush.end.then ->
  backToPosition = scrollPositions.get('HotCodePushScrollPosition')
  if backToPosition
    scheduleScroll()

FlowRouterAutoscroll.scrollPositions = scrollPositions
FlowRouterAutoscroll.init = init
