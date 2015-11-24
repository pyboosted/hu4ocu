package pages;

import Mithril.*;
import layout.Layout;

typedef ChatConfig = {
  title: String,
  disabled: Bool,
  ?active: Bool
};

enum ChatStatus {
  NotConnected;
  Connected;
  Connecting;
}

class Chats {
  var chats = ['Rutony', 'Twitch', 'Goodgame', 'Youtube', 'sc2tv'];
  public function new(_) {}

  function wrapChat(chat:ChatConfig, ?content = null) {
    return m('.lightblock' + (chat.disabled ? '.disabled' : ''), [
      m('.small-header' + (chat.active ? '.active' : '') , chat.title),
      m('ul.items-list', [
        m('li', content),
      ])
    ]);
  }

  var status: ChatStatus = NotConnected;
  public function connect(provider) {
    status = Connecting;
    haxe.Timer.delay(function () {
      status = Connected;
      redraw();
    }, 1000);
  }

  public function disconnect(provider) {
    status = NotConnected;
  }

  public function view() return Layout.around([
    wrapChat({ title: 'Rutony', active: (status == Connected), disabled: false }, [
      switch(status) { 
        case Connecting:
          m('.status', 'Connecting...');
        case Connected:
          m('.row', [
            m('.col[style="width:70%"]', m('.status', 'Connected')),
            m('.col[style="width:30%"]', m('button.btn-dark', { onclick: function () disconnect('rutony') }, 'Disconnect'))
          ]);
        case NotConnected:
          m('.row', [
            m('.col[style="width:70%"]', m('input[type="text"][placeholder="URL"][value="http://127.0.0.1:8383/Echo"]')),
            m('.col[style="width:30%"]', m('button', { onclick: function () connect('rutony') }, 'Connect'))
          ]);
      }
    ]),
    wrapChat({ title: 'Twitch', disabled: true }, [
      m('.row', [
        m('.col[style="width:70%"]', m('input[type="text"][placeholder="Channel"]')),
        m('.col[style="width:30%"]', m('button', 'Connect'))
      ])
    ]),
    wrapChat({ title: 'Goodgame', disabled: true }, [
      m('.row', [
        m('.col[style="width:70%"]', m('input[type="text"][placeholder="Channel"]')),
        m('.col[style="width:30%"]', m('button', 'Connect'))
      ])
    ]),
    wrapChat({ title: 'Youtube', disabled: true }, [
      m('.row', [
        m('.col[style="width:70%"]', m('input[type="text"][placeholder="Channel"]')),
        m('.col[style="width:30%"]', m('button', 'Connect'))
      ])
    ])
  ]);
}