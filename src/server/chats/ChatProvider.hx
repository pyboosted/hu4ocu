package chats;

import chats.ChatProviderStatus;

class ChatProvider {
  private var _status: ChatProviderStatus = ChatProviderStatus.Disconnected;
  private var _messageListeners: Array<Message->Void> = [];
  private var _attempsLeft = 2;
  public function new() {

  }

  public function getStatus() {
    return _status;
  }
  public function setStatus(status: ChatProviderStatus) {
    if (status != _status) {
      _status = status;
      _notifyStatusChanged(status);
    }
  }

  public function connect() {
    throw "Not implemented";
  }
  public function disconnect() {
    throw "Not implemented";
  }
  var _statusListeners: Array<ChatProviderStatus->Void> = [];
  public function onStatusChanged(fn: ChatProviderStatus->Void) {
    _statusListeners.push(fn);
  }

  private function _notifyStatusChanged(status) {
    for (listener in _statusListeners) {
      listener(status);
    }
  }

  
  public function onMessage(fn: Message->Void) {
    _messageListeners.push(fn);
  }

  public function notifyListeners(message: Message) {
    for (listener in _messageListeners) {
      listener(message);
    }
  }

  private function _onConnect(_) {
    setStatus(ChatProviderStatus.Connected);
  }

  private function _onDisconnect(_) {
    setStatus(ChatProviderStatus.Disconnected);
    if (_attempsLeft > 0) {
      setStatus(ChatProviderStatus.Pending);
      _attempsLeft--;
      haxe.Timer.delay(function () connect(), 3000);
    }
  }


}