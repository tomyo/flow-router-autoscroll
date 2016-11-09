Package.describe({
  name: 'tomyo:flow-router-autoscroll',
  version: '0.0.1',
  summary: 'Smart management of scroll position across route changes for Flow Router',
  git: 'https://github.com/tomyo/flow-router-autoscroll',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4.2');
  api.use('ecmascript');
  api.use('coffeescript');
  api.use('reactive-dict');
  api.use('reload');
  api.use('kadira:flow-router', 'client', {weak: true});
  api.addFiles('client/hot-code-push.coffee', 'client');
  api.mainModule('client/flow-router-autoscroll.coffee', 'client');
  api.export('FlowRouterAutoscroll', 'client');
});

//Package.onTest(function(api) {
//  api.use('ecmascript');
//  api.use('tinytest');
//  api.use('tomyo:flow-router-autoscroll');
//  api.mainModule('flow-router-autoscroll-tests.js');
//});
