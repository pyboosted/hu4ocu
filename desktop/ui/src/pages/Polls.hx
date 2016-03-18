package pages;

import Mithril.*;
import layout.Layout;

using Lambda;

class Polls {
  
  public function new(_) {



  }

  private function onChange(fn) {
    return function (el, _) {
      el.oninput = function () {
        fn(el.value);
      }
    };
  }

  function save(config) {
    UI.polls.update(config, function (_) {});
  }
  function run() {
    UI.polls.start(function(_) {});
  }
  function stop() {
    UI.polls.stop(function(_) {});
  }
  function resume() {
    UI.polls.start(function(_) {});
  }
  function show() {
    UI.polls.show(function(_) {});
  }
  function hide() {
    UI.polls.hide(function(_) {});
  }
  function reset() {
    UI.polls.reset(function(_) {});
  }

  public function view() {
    
    var config = UI.polls.get();
    var localConfig = {
      q1: config.q1,
      q2: config.q2,
      key1: config.key1,
      key2: config.key2      
    };

    trace(config);

    return Layout.around(
      m('.page', [
        m('.lightblock', [
          m('.small-header', 'Polls'),
          m('ul.items-list', [
            m('li.row', [
              m('.col[style="width:50%;"]', [
                m('.label', 'Team 1'),
                m('input[type="text"][placeholder="Team 1"][value="${localConfig.q1}"]', {
                  config: onChange(function (v) localConfig.q1 = v)
                }),
                m('.label', 'Key 1'),
                m('input[type="text"][placeholder="Key 1"][value="${localConfig.key1}"]', {
                  config: onChange(function (v) localConfig.key1 = v)
                })
              ]),
              m('.col[style="width:50%;"]', [
                m('.label', 'Team 2'),
                m('input[type="text"][placeholder="Team 2"][value="${localConfig.q2}"]', {
                  config: onChange(function (v) localConfig.q2 = v)
                }),
                m('.label', 'Key 2'),
                m('input[type="text"][placeholder="Key 2"][value="${localConfig.key2}"]', {
                  config: onChange(function (v) localConfig.key2 = v)
                })
              ]),
              m('.col.pad-top', m('button', {
                onclick: function () {
                  save(localConfig);
                }
              }, 'Save'))
            ]),
            m('li.row', [
              m('.col[style="width:50%;"]', m('.votes-count', config.votes1.length)),
              m('.col[style="width:50%;"]', m('.votes-count', config.votes2.length)),
            ]),
            m('li.row', [
              m('.col[style="width:50%;"]', m('.parts', [
                m('textarea[rows="5"]', config.votes1.map(function (v) {
                  return '${v.user}';
                }).join('\n'))
              ])),
              m('.col[style="width:50%;"]', m('.parts', [
                m('textarea[rows="5"]', config.votes2.map(function (v) {
                  return '${v.user}';
                }).join('\n'))
              ])),
              m('.col', m('button', { onclick: function () reset() }, 'Reset'))
            ]),
            m('li.row', [
              m('.col[style="width:50%;"]', [
                switch(config.status) {
                  case Running:
                    m('button.btn-dark', { onclick: function () stop() }, 'Stop');
                  case NotRunning:
                    m('button.btn-dark', { onclick: function () run() }, 'Start');
                  case Stopped:
                    m('button.btn-dark', { onclick: function () resume() }, 'Resume');
                }
              ]),
              m('.col[style="width:50%;"]', [
                switch(config.visual) {
                  case Hidden:
                    m('button', { onclick: function () show() }, 'Show');
                  case Visible:
                    m('button', { onclick: function () hide() }, 'Hide');
                }
              ])
            ]),
          ])
        ]),
      ])
    );
  }
}