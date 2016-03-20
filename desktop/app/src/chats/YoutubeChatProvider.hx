package chats;

import ws.WebSocket;
import chats.ChatProvider;

import Formats;

using StringTools;

@:jsRequire('child_process')
extern class ChildProcess {
  public static function spawn(processName: String, args: Array<String>):Dynamic;
}

@:jsRequire('os')
extern class OS {
  public static function platform():String;
}

class YoutubeChatProvider extends ChatProvider {

  var host: String;
  var channel: String;
  var phantom: Dynamic;
  var firstTick: Bool = true;
  public function new(host: String) {
    this.host = host;
    super();
  }

  public override function connect(channel) {
    
    firstTick = true;

    tryReconnect = true;
    this.channel = channel;

    setStatus(ChatProviderStatuses.Pending);

    var isWindows = (OS.platform().startsWith('win'));
    
    var phantomPath = isWindows ? 'phantomjs.exe' : './node_modules/.bin/phantomjs';
    var ytParserPath = isWindows ? 'resources/app/bin/utils/yt-parser.js' : './bin/utils/yt-parser.js';

    phantom = ChildProcess.spawn(phantomPath, [ytParserPath, channel]);
    phantom.stdout.on('data', function (data) {
      if (firstTick) {
        this.onConnect(null);
        firstTick = false;
      }
      var text = data.toString();
      processMessage(text);

    });

    phantom.on('close', function () {
      this.onDisconnect(null);
    });
    
  }

  public override function onConnect(_) {
    setStatus(ChatProviderStatuses.Connected);
  }

  public override function disconnect() {
    tryReconnect = false;
    channel = null;
    phantom.kill();
    phantom = null;
    setStatus(ChatProviderStatuses.Disconnected);
  } 

  function processMessage(data: Dynamic):Void {

    var messages:Array<String> = data.split('\n');
    for (msg in messages) {
      if (msg.indexOf('|||') == -1) continue;
      var messageData = msg.split('|||');
      var message:ChatMessage = {
        source: MessageSources.Youtube,
        username: messageData[0],
        text: messageData[1]
      };
      this.notifyListeners(message);

    }
    
  }
}