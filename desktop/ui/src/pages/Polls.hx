package pages;

import Mithril.*;
import layout.Layout;

class Polls {
  public function new(_) {}
  public function view() return Layout.around(
    m('.page', [
      m('.lightblock', [
        m('.small-header', 'Polls'),
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
            ]),
            m('.col.pad-top', m('button', 'Save'))
          ]),
          m('li.row', [
            m('.col[style="width:50%;"]', m('.votes-count', 0)),
            m('.col[style="width:50%;"]', m('.votes-count', 0)),
          ]),
          m('li.row', [
            m('.col[style="width:50%;"]', m('.parts', [
              m('textarea[rows="5"]')
            ])),
            m('.col[style="width:50%;"]', m('.parts', [
              m('textarea[rows="5"]')
            ])),
            m('.col', m('button', 'Reset'))
          ]),
          m('li.row', [
            m('.col[style="width:50%;"]', [
              m('button.btn-dark', 'Run')
            ]),
            m('.col[style="width:50%;"]', [
              m('button', 'Show')
            ])
          ]),
        ])
      ]),
    ])
  );
}