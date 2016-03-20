package pages;

import Mithril.*;
import layout.Layout;
import services.Validator;

import Formats;

using Lambda;

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
  
  var chatProviders: Map<String, Dynamic>;
  var chats = ['twitch', 'goodgame', 'youtube'];
  var validator: Validator;
  var messages: Array<ChatMessage>;

  function toEmpty(str: String) {
    if (str == null) return '';
    return str;
  }

  public function new(_) {

    validator = new Validator([
      'channel' => [Required, Type(Text)]
    ]);

    chatProviders = new Map<String, Dynamic>();
    chatProviders.set('twitch', {
      title: 'Twitch',
      placeholder: 'Channel name',
      input: toEmpty(UI.chats.providers.get('twitch').channel)
    });
    chatProviders.set('goodgame', {
      title: 'Goodgame',
      placeholder: 'Channel id',
      input: toEmpty(UI.chats.providers.get('goodgame').channel)
    });
    chatProviders.set('youtube', {
      title: 'Youtube',
      placeholder: 'Channel id',
      input: toEmpty(UI.chats.providers.get('youtube').channel)
    });

    messages = UI.chats.getMessages();

  }

  function wrapChat(chat:ChatConfig, ?content = null) {
    return m('.lightblock' + (chat.disabled ? '.disabled' : ''), [
      m('.small-header' + (chat.active ? '.active' : '') , chat.title),
      m('ul.items-list', [
        m('li', content),
      ])
    ]);
  }

  var status: ChatStatus = NotConnected;
  public function connect(provider, channel) {
    UI.chats.connect(provider, channel);
  }

  public function disconnect(provider) {
    UI.chats.disconnect(provider);
  }

  public function view() return Layout.around(
    m('.chats', [ 
      m('.controls', chats.map(function (chat) {

        var chatProvider = chatProviders.get(chat);
        trace(chat, chatProvider);
        var title = chatProvider.title;
        var placeholder = chatProvider.placeholder;

        var status:ChatProviderStatuses = UI.chats.providers.get(chat).status;

        var currentChannel = UI.chats.providers.get(chat).channel;

        return wrapChat({ title: title, active: (status == Connected), disabled: false }, [
          switch(status) { 
            case ChatProviderStatuses.Pending:
              m('.status', 'Connecting to $currentChannel...');
            case ChatProviderStatuses.Connected:
              m('.row', [
                m('.col[style="width:70%"]', m('.status', 'Connected to $currentChannel')),
                m('.col[style="width:30%"]', m('button.btn-dark', { onclick: function () disconnect(chat) }, 'Disconnect'))
              ]);
            case ChatProviderStatuses.Disconnected:
              m('.row', [
                m('.col[style="width:70%"]', m('input[type="text"][placeholder="$placeholder"][value="${chatProvider.input}"]', {
                  config: function (el, _) {
                    el.oninput = function () {
                      chatProvider.input = el.value;
                    };
                  }
                })),
                m('.col[style="width:30%"]', m('button', { onclick: function () connect(chat, chatProvider.input) }, 'Connect'))
              ]);
          }
        ]);
      })),
      wrapChat({ title: 'Messages', active: false, disabled: false }, [ 
        m('.chats-wrapper', messages.map(function (message) {
          return m('.message', '[${message.source}] ${message.username}: ${message.text}');
        }))
      ])
    ])
  );
}