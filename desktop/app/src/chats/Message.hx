package chats;

@:enum abstract MessageSource(String) {
  var Youtube = 'youtube';
  var Twitch = 'twitch';
  var Goodgame = 'goodgame';
}

typedef Message = {
  public var source: MessageSource;
  public var username: String;
  public var text: String;
}