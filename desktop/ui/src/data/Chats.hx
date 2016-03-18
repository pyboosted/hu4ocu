package data;

@async class Chats {

  var providers: Map<String, ChatProviderStatuses>;
  public function new() {
    providers = new Map<String, ChatProviderStatuses>();

    for(prop in Type.allEnums(ChatProviders)) {
      providers[prop] = ChatProviderStatuses.Disconnected;
    }

    API.on('chat.disconnected', function (provider: ChatProviders) {
      providers[provider] = ChatProviderStatuses.Disconnected;
    });
  }

  @async public function connect(provider: ChatProviders):Void {
    providers[provider] = ChatProviderStatuses.Pending;
    [var result] = API.getAsync('chat.connect', provider);
    providers[provider] = result;

    return result;
  }

  @async public function disconnect(provider: ChatProviders):Void {
    providers[provider] = ChatProviderStatuses.Pending;
    [var result] = API.getAsync('chat.disconnect', provider);
    providers[provider] = result;
    return result;
  }

  public function getStatus(provider: ChatProviders):ChatProviderStatuses {
    return providers[provider];
  }

}