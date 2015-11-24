package pages;

import Mithril.*;
import layout.Layout;

class Dashboard {
  public function new(_) {}
  public function view() return Layout.around(
    m('.lightblock', [
      m('.header', 'Dashboard'),
      m('ul.items-list', [
        m('li', 'Chats'),
        m('li', 'Polls'),
        m('li', 'Wheel')
      ])
    ])
  );
}