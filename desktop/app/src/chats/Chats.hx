package chats;

import chats.ChatProvider;

import chats.RutonyChatProvider;

import Formats;

class Chats {
  private var messageListeners: Array<ChatMessage->Void> = [];
  private var changeListeners: Array<ChatProviders->ChatProviderStatuses->Void> = [];
  
  var app: App;

  var chatProviders: Map<String, ChatProvider>;
  public function new(app: App) {
    
    this.app = app;

    chatProviders = new Map<String, ChatProvider>();

    var rutonyChatProvider = new RutonyChatProvider('http://127.0.0.1:8383/Echo');
    rutonyChatProvider.onMessage(notifyListeners);
    rutonyChatProvider.onStatusChanged(function (status) {
      notifyStatusChanged(ChatProviders.Rutony, status);
    });

    var twitchChatProvider = new TwitchChatProvider(null);
    twitchChatProvider.onMessage(notifyListeners);
    twitchChatProvider.onStatusChanged(function (status) {
      notifyStatusChanged(ChatProviders.Twitch, status);
    });

    var goodgameChatProvider = new GoodgameChatProvider('ws://chat.goodgame.ru:8081/chat/websocket');
    goodgameChatProvider.onMessage(notifyListeners);
    goodgameChatProvider.onStatusChanged(function (status) {
      notifyStatusChanged(ChatProviders.Goodgame, status);
    });

    chatProviders.set(cast ChatProviders.Rutony, rutonyChatProvider);
    chatProviders.set(cast ChatProviders.Twitch, twitchChatProvider);
    chatProviders.set(cast ChatProviders.Goodgame, goodgameChatProvider);

    app.ui.when('chat.connect', function (data) {
      trace('chat.connect', data);
      chatProviders.get(data.provider).connect(data.channel);
      return null;
    });
    app.ui.when('chat.disconnect', function (data) {
      trace('chat.disconnect', data);
      chatProviders.get(data.provider).disconnect();
      return null;
    });

    this.onStatusChanged(function (provider, status) {
      trace('status changed', provider, status);
      switch(status) {
        case Connected:
          app.ui.notify('chat.connected', { provider: provider, status: status });
        case Disconnected:
          app.ui.notify('chat.disconnected', { provider: provider, status: status });
        case Pending:
      }
    });
  }

  public function get(provider: ChatProviders): ChatProvider {
    return chatProviders.get(cast provider);
  }

  public function onMessage(fn: ChatMessage->Void) {
    messageListeners.push(fn);
  }

  public function onStatusChanged(fn: ChatProviders->ChatProviderStatuses->Void) {
    changeListeners.push(fn);
  }

  public function notifyListeners(message: ChatMessage) {
    for (listener in messageListeners) {
      listener(message);
    }
    app.ui.notify('chat.message', message);
  }
  public function notifyStatusChanged(provider: ChatProviders, status) {
    for (listener in changeListeners) {
      listener(provider, status);
    }
  }

}