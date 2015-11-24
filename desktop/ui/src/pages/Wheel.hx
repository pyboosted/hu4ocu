package pages;

import Mithril.*;
import layout.Layout;

class Wheel {
  public function new(_) {}
  public function view() return Layout.around(
    m('.lightblock', [
      m('.header', 'Wheel'),
      m('ul.items-list', [
        m('li', 'Chats'),
        m('li', 'Polls'),
        m('li', 'Wheel')
      ])
    ])
  );
}