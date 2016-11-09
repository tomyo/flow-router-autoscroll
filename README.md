Autoscroll for Meteor
==========================

Based/Forked from [Autoscroll for Iron Router](https://github.com/okgrow/iron-router-autoscroll) by OK GROW!

This package extends the above package functionality, adding support for black
listing routes where you don't want to autoscroll. Also, Iron router support was
dropped here, simply because I don't use it.

A [Flow Router](https://atmospherejs.com/kadira/flow-router) enhancement that improves navigation for pages that have more than one screen-full of content.
It causes the page to scroll to the right place after changing routes (which people are often surprised to find doesn't happen by default).

"The right place" is:

1. The previous position if we're returning via the back button, or
2. The element whose id is specified in the URL hash (if present), or
3. The top of page otherwise

Why?
----

In The Old Days™ when you navigated to a new page the browser would unload the current page, load the new page, and position the viewport to the top of the page.
If the link had an anchor/hash (e.g. `#something`) the browser would scroll down to the top of the element with that id.

When changing routes using modern apps with client-side routers the browser doesn't technically load a new page,
it just changes content in the existing page (as far as the browser is concerned) so it doesn't scroll to the top.
The viewport stays in the same place it was already.
So when navigating from a page that's scrolled down already this feels to the user like navigating to a new page and being scrolled partway down, which feels unnatural.

Installation
----------

`meteor add tomyo:flow-router-autoscroll`


Usage
-----

In your client code, call `FlowRouterAutoscroll.init()`. You can pass options
to set `animationDuration`, `marginTop` and `except` (to ignores routes).


Options
-----------

The animation speed defaults to 200 ms.
To change this use:

``` javascript
FlowRouterAutoscroll.animationDuration = 100;
```

For some cases (top fixed elements), margins are needed.
To set this use:

``` javascript
FlowRouterAutoscroll.marginTop = 50;
```

You can also maintain scroll position to certain routes. To do so, add the route
names to the `except` option.

``` javascript
FlowRouterAutoscroll.except = ['home', 'routeWithTabs'];
```

Example:

```javascript
FlowRouterAutoscroll.animationDuration = 100;
FlowRouterAutoscroll.marginTop = 50;
FlowRouterAutoscroll.except = ['home', 'routeWithTabs'];
FlowRouterAutoscroll.init()
```

 Or better:

 ```javascript
 options = {
   animationDuration: 100,
   marginTop: 50,
   except: ['home', 'routeWithTabs']
 }
 FlowRouterAutoscroll.init(options)
 ```

Considerations
--------------

* Due to flow-router desing, changing `except` option after calling `init()` won't
have any effect.

Hot Code Push
-----------

The scroll position will be restored after a hot code push.

Hot code pushes actually do a `window.location.reload()`, breaking
from the single-page-app (SPA) paradigm, but we use the HotCodePush
module to set up the saving/restoring of scroll position.

Known issues
------------

1. There are a few edge cases which aren't supported yet (around navigation using the back button and pages which load dynamic content after the route change).
PR's are welcome.

Contributing
------------

Issues and Pull Requests are always welcome.

Other notes
---------------

This package enhances Flow Router, but it does not force a install of the
package since its dependency is declared as `{weak: true}`.


### License

Released under the [MIT license](https://github.com/tomyo/flow-router-autoscroll/blob/master/License.md).
