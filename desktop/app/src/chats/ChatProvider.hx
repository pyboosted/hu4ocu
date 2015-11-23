package chats;

import chats.ChatProviderStatus;

class ChatProvider {
  private var status: ChatProviderStatus = ChatProviderStatus.Disconnected;
  private var messageListeners: Array<Message->Void> = [];
  private var attempsLeft = 2;
  public function new() {

  }

  public function getStatus() {
    return status;
  }
  public function setStatus(status: ChatProviderStatus) {
    if (this.status != status) {
      this.status = status;
      notifyStatusChanged(status);
    }
  }

  public function connect() {
    throw "Not implemented";
  }
  public function disconnect() {
    throw "Not implemented";
  }
  var statusListeners: Array<ChatProviderStatus->Void> = [];
  public function onStatusChanged(fn: ChatProviderStatus->Void) {
    statusListeners.push(fn);
  }

  private function notifyStatusChanged(status) {
    for (listener in statusListeners) {
      listener(status);
    }
  }

  
  public function onMessage(fn: Message->Void) {
    messageListeners.push(fn);
  }

  public function notifyListeners(message: Message) {
    for (listener in messageListeners) {
      listener(message);
    }
  }

  private function onConnect(_) {
    setStatus(ChatProviderStatus.Connected);
  }

  private function onDisconnect(_) {
    if (attempsLeft > 0) {
      setStatus(ChatProviderStatus.Pending);
      attempsLeft--;
      haxe.Timer.delay(function () connect(), 3000);
    } else {
      setStatus(ChatProviderStatus.Disconnected);
    }
  }


}