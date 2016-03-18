package chats;

import chats.ChatProvider;
import chats.RutonyChatProvider;
import chats.ChatProviders;

class Chats {
  private var messageListeners: Array<Message->Void> = [];
  var chatProviders: Map<String, ChatProvider>;
  public function new(app: App) {
    chatProviders = new Map<String, ChatProvider>();

    var rutonyChatProvider = new RutonyChatProvider('http://127.0.0.1:8383/Echo');
    rutonyChatProvider.onMessage(notifyListeners);

    var twitchChatProvider = new TwitchChatProvider('ws://192.16.64.145:80');
    twitchChatProvider.onMessage(notifyListeners);

    var goodgameChatProvider = new GoodgameChatProvider('ws://chat.goodgame.ru:8081/chat/websocket');
    goodgameChatProvider.onMessage(notifyListeners);
    
    chatProviders.set(cast ChatProviders.Rutony, rutonyChatProvider);
    chatProviders.set(cast ChatProviders.Twitch, twitchChatProvider);
    chatProviders.set(cast ChatProviders.Goodgame, goodgameChatProvider);
  }

  public function get(provider: ChatProviders): ChatProvider {
    return chatProviders.get(cast provider);
  }

  public function onMessage(fn: Message->Void) {
    messageListeners.push(fn);
  }

  public function notifyListeners(message: Message) {
    for (listener in messageListeners) {
      listener(message);
    }
  }

}