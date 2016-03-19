package chats;

import Formats;

class ChatProvider {

  private var status: ChatProviderStatuses = ChatProviderStatuses.Disconnected;
  private var messageListeners: Array<ChatMessage->Void> = [];
  private var attempsLeft = 2;
  var tryReconnect:Bool = true;
  public function new() {

  }

  public function getStatus() {
    return status;
  }
  public function setStatus(status: ChatProviderStatuses) {
    if (this.status != status) {
      this.status = status;
      notifyStatusChanged(status);
    }
  }

  public function connect(_) {
    throw "Not implemented";
  }
  public function disconnect() {
    throw "Not implemented";
  }
  var statusListeners: Array<ChatProviderStatuses->Void> = [];
  public function onStatusChanged(fn: ChatProviderStatuses->Void) {
    statusListeners.push(fn);
  }

  private function notifyStatusChanged(status) {
    for (listener in statusListeners) {
      listener(status);
    }
  }

  
  public function onMessage(fn: ChatMessage->Void) {
    messageListeners.push(fn);
  }

  public function notifyListeners(message: ChatMessage) {
    for (listener in messageListeners) {
      listener(message);
    }
  }

  private function onConnect(_) {
    setStatus(ChatProviderStatuses.Connected);
  }

  private function onDisconnect(_) {
    if (attempsLeft > 0 && tryReconnect) {
      setStatus(ChatProviderStatuses.Pending);
      attempsLeft--;
      haxe.Timer.delay(function () connect(null), 3000);
    } else {
      setStatus(ChatProviderStatuses.Disconnected);
    }
  }


}