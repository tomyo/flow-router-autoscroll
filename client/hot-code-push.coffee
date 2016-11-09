hcp = new ReactiveDict('fr-hot-code-push')

debug = (msg) ->
  console.info msg
  return

fakeStartPromise =
  then: (actionFn) ->
    debug("scheduled begin and end hook")
    hcp.set 'has-hcp-hook', true
    Reload._onMigrate ->
      try
        actionFn()
      catch ex
        console.log 'error', ex
      return [true]
    return fakeStartPromise

HotCodePush =
  start: fakeStartPromise
  end: new Promise((resolve) ->
    hcp.set 'has-hcp-hook', true
    window.addEventListener 'load', ->
      debug("detected window load")
      if hcp.get('has-hcp-hook')
        debug("HotCodePush.end promise resolving");
        hcp.set 'has-hcp-hook', undefined
        resolve true
  )

share.HotCodePush = HotCodePush
