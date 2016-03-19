package data;

import Formats;

typedef ChatProviderStatus = {
  status: ChatProviderStatuses,
  channel: String
};

class Chats {

  public var providers: Map<String, ChatProviderStatus>;
  public var messages: Array<ChatMessage>;
  public function new() {

    var chats = ['goodgame', 'twitch', 'youtube'];

    providers = new Map<String, ChatProviderStatus>();
    messages = new Array<ChatMessage>();

    for(prop in chats) {
      providers.set(cast prop, {
        status: ChatProviderStatuses.Disconnected,
        channel: null
      });
    }


    API.on('chat.disconnected', function (data) {
      trace('chat.disconnected', data);
      providers.get(data.provider).status = ChatProviderStatuses.Disconnected;
      providers.get(data.provider).channel = null;
      UI.update();
      return null;
    });

    API.on('chat.connected', function (data) {
      trace('chat.connected', data);
      providers.get(data.provider).status = ChatProviderStatuses.Connected;
      // providers.get(data.provider).channel = data.channel;
      UI.update();
      return null;
    });

    API.on('chat.message', function (message) {
      messages.push(message);
      UI.update();
      return null;
    });
  }

  public function connect(provider: String, channel: String):Void {
    providers.get(provider).status = ChatProviderStatuses.Pending;
    providers.get(provider).channel = channel;
    API.get('chat.connect', { provider: provider, channel: channel });
  }

  public function disconnect(provider: String):Void {
    providers.get(provider).status = ChatProviderStatuses.Pending;
    API.get('chat.disconnect', { provider: provider });
  }

  public function getStatus(provider: String):ChatProviderStatus {
    return providers.get(provider);
  }

  public function getMessages():Array<ChatMessage> {
    return messages;
  }

}