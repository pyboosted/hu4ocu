package pages;

import Mithril.*;
import layout.Layout;

class Wheel {
  public function new(_) {}
  public function view() return Layout.around(
    m('.lightblock', [
      m('.small-header', 'Wheel'),
      m('ul.items-list', [
        m('li', [
          m('.label', 'Participants'),
          m('textarea[style="height: 200px"]')
        ]),
        m('li', [
          m('button', 'Roll')
        ]),
      ])
    ])
  );
}