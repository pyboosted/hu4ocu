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
          m('textarea[style="height: 235px"]')
        ]),
        m('li.row', [
          m('.col[style="width:50%;"]', [
            m('button', 'Save')
          ]),
          m('.col[style="width:50%;"]', [
            m('button', 'Shuffle')
          ])
        ]),
        m('li', [
          m('.votes-count', 'Not rolling yet')
        ]),
        m('li.row', [
          m('.col[style="width:50%;"]', [
            m('button.btn-dark', 'Roll')
          ]),
          m('.col[style="width:50%;"]', [
            m('button', 'Show')
          ])
        ]),
      ])
    ])
  );
}