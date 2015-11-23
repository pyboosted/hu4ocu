package chats;

@:enum abstract ChatProviderStatus(String) {
  var Disconnected = 'disconnected';
  var Connected = 'connected';
  var Pending = 'pending';
}