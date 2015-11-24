package pages;

import Mithril.*;
import layout.Layout;

class About {
  public function new(_) {}
  public function view() return m('.lightblock', [
    m('.header', 'About'),
    m('ul.items-list', [
      m('li', 'Chats'),
      m('li', 'Polls'),
      m('li', 'Wheel')
    ])
  ]);
}