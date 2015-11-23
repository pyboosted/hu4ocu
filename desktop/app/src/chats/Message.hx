package chats;

enum MessageSource {
  Youtube;
  Twitch;
  Goodgame;
}

typedef Message = {
  public var source: MessageSource;
  public var username: String;
  public var text: String;
}