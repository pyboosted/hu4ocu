package chats;

import chats.ChatProvider;
import chats.RutonyChatProvider;
import chats.ChatProviders;

class Chats {
  private var messageListeners: Array<Message->Void> = [];
  var chatProviders: Map<String, ChatProvider>;
  public function new() {
    chatProviders = new Map<String, ChatProvider>();

    var rutonyChatProvider = new RutonyChatProvider('http://127.0.0.1:8383/Echo');
    rutonyChatProvider.onStatusChanged(function (status) {
      trace('Rutony: $status');
    });
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