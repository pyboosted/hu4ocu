package chats;

import chats.ChatProvider;
import chats.RutonyChatProvider;
import chats.ChatProviders;

class Chats {
  private var messageListeners: Array<Message->Void> = [];
  var chatProviders: Map<String, ChatProvider>;
  public function new(app: Server) {
    chatProviders = new Map<String, ChatProvider>();

    var rutonyChatProvider = new RutonyChatProvider('http://127.0.0.1:8383/Echo');
    rutonyChatProvider.onMessage(notifyListeners);

    chatProviders.set(cast ChatProviders.Rutony, rutonyChatProvider);
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