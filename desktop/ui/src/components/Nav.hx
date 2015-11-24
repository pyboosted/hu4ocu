package components;

import Mithril.*;

typedef NavItem = {
  href: String,
  text: String,
  ?disabled: Bool
}

class Nav {
  var items:Array<NavItem> = [{
    href: '/dashboard',
    text: 'Dashboard'
  }, {
    href: '/chats', 
    text: 'Chats'
  }, {
    href: '/polls',
    text: 'Polls',
    disabled: true
  }, {
    href: '/wheel',
    text: 'Wheel',
    disabled: true
  }];

  public function new(_) {}
  public function view() return m('.darkblock', [ 
    m('.header', 'Tools'),
    m('ul.nav', [for(item in items)
      m('li', m('a', { onclick: setRoute.bind(item.href) }, item.text))
    ]),
    m('.small-link', m('a', {},'About'))
  ]);
}