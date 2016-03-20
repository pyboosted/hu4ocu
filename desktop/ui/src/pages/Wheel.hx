package pages;

import Mithril.*;
import layout.Layout;

import Formats;

class Wheel {
  var config:WheelConfig;
  var localList:Array<String> = [];
  function none(err: Dynamic):Void {
    redraw();
  }

  public function new(_) {
    config = UI.wheel.getConfig();
  }

  private function onChange(fn) {
    return function (el, _) {
      el.oninput = function () {
        fn(el.value);
      }
    };
  }

  function save(list) {
    config.list = list;
    UI.wheel.update(localList, none);
  }

  function shuffle() {
    UI.wheel.shuffle(none);
  }

  function roll() {
    UI.wheel.start(none);
  }

  function stop() {
    UI.wheel.stop(none);
  }

  function show() {
    UI.wheel.show(none);
  }

  function hide() {
    UI.wheel.hide(none);
  }

  public function view() {

    var isRunning:Bool = (config.status != NotRunning && config.status != Stopped);
    var isRunningDisabled = isRunning ? '.disabled' : '';
    var isHidden:Bool = (config.visual == Hidden);
    var isHiddenDisabled = isHidden ? '.disabled' : '';
    var winner = '';

    localList = config.list;

    trace(config);
    if (config.winner != null) {
      winner = config.list[config.winner];
    }

    return Layout.around(
      m('.lightblock', [
        m('.small-header', 'Wheel'),
        m('ul.items-list', [
          m('li', [
            m('.label', 'Participants'),
            m('textarea[style="height: 235px"]', {
              config: onChange(function (v) localList = v.split('\n'))
            }, localList.join('\n'))
          ]),
          m('li.row', [
            m('.col[style="width:50%;"]', [
              m('button$isRunningDisabled', { onclick: function () save(localList) }, 'Save')
            ]),
            m('.col[style="width:50%;"]', [
              m('button$isRunningDisabled', { onclick: function () shuffle() },  'Shuffle')
            ])
          ]),
          m('li', [
            m('.votes-count', 
              switch(config.status) {
                case NotRunning:
                  'Not rolling yet';
                case Speeding:
                  'Speeding up...';
                case Running:
                  'Rolling. Press stop.';
                case Slowing:
                  'Slowing down...';
                case Stopped:
                  'Winner is $winner';
              }
            )
          ]),
          m('li.row', [
            m('.col[style="width:50%;"]', [
              switch(config.status) {
                case NotRunning:
                  m('button.btn-dark$isHiddenDisabled', { onclick: function () roll() }, 'Roll');
                case Speeding:
                  m('button.btn-dark.disabled', 'Speeding...');
                case Running:
                  m('button.btn-dark', { onclick: function () stop() }, 'Stop');
                case Slowing:
                  m('button.btn-dark.disabled', 'Slowing...');
                case Stopped:
                  m('button.btn-dark$isHiddenDisabled', { onclick: function () roll() }, 'Roll again');
              }
            ]),
            m('.col[style="width:50%;"]', [
              (config.visual == Hidden) ? 
                m('button', { onclick: function () show() }, 'Show') :
                m('button$isRunningDisabled', { onclick: function () hide() }, 'Hide')
            ])
          ]),
        ])
      ])
    );
  }
}