package pages;

import Mithril.*;
import layout.Layout;

class Polls {
  public function new(_) {}
  public function view() return Layout.around(
    m('.page', [
      m('.lightblock', [
        m('.small-header', 'Preview'),
        m('ul.items-list', [
          m('iframe[src="http://127.0.0.1:8080/polls/index.html"][frameBorder="0"][style="width: 100%; height: 100px;"]')
        ])
      ]),
      m('.lightblock', [
        m('.small-header', 'Settings'),
        m('ul.items-list', [
          m('li.row', [
            m('.col[style="width:50%;"]', [
              m('.label', 'Team 1'),
              m('input[type="text"][placeholder="Team 1"][value="Team 1"]'),
              m('.label', 'Key 1'),
              m('input[type="text"][placeholder="Key 1"][value="1"]')
            ]),
            m('.col[style="width:50%;"]', [
              m('.label', 'Team 2'),
              m('input[type="text"][placeholder="Team 2"][value="Team 2"]'),
              m('.label', 'Key 2'),
              m('input[type="text"][placeholder="Key 2"][value="2"]')
            ])
          ]),
          m('li', [
            m('button', 'Запустить')
          ])
        ])
      ])
    ])
  );
}