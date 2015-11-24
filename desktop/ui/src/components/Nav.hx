package components;

import Mithril.*;

using StringTools;

typedef NavItem = {
  href: String,
  text: String,
  ?status: String
}

class Nav {
  var items:Array<NavItem> = [{
    href: '/chats', 
    text: 'Chats',
    status: 'success',
  }, {
    href: '/polls',
    text: 'Polls'
  }, {
    href: '/wheel',
    text: 'Wheel'
  }];

  public function new(_) {}

  function findActive() {
    var route = getRoute();
    var active = null;
    for(item in items) if(item != null) {
      if(route == item.href) return item;
      else if(route.startsWith(item.href)) {
        active = item;
      }
    }
    return active;
  }

  public function view() return m('.darkblock', [ 
    m('.header', 'Tools'),
    m('ul.nav', [for(item in items)
      m('li' + ((item == findActive()) ? '.active' : '' ), [
        m('a' + ((item.status != null) ? '.' + item.status : '' ), 
          { onclick: setRoute.bind(item.href) }, 
          item.text)
      ])
    ]),
    m('.small-link', m('a', { onclick: setRoute.bind('/about') },'About'))
  ]);
}