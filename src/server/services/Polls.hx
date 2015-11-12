package services;

import services.Service;

using StringTools;

@:enum abstract PollsStatus(String) {
  var NotRunning = 'not_running';
  var Running = 'running';
  var Stopped = 'stopped';
}

@:enum abstract PollsVisual(String) {
  var Visible = 'visible';
  var Hidden = 'hidden';
}


typedef PollsConfig = {
  status: PollsStatus,
  visual: PollsVisual,
  key1: String,
  key2: String,
  q1: String,
  q2: String,
  votes1: Array<String>,
  votes2: Array<String>
};



class Polls extends Service {

  var config: PollsConfig;
  public function new(app) {
    super(app);

    config = {
      status: NotRunning,
      visual: Hidden,
      key1: '1',
      key2: '2',
      q1: 'Team 1',
      q2: 'Team 2',
      votes1: [],
      votes2: []
    };

    app.chats.onMessage(function (message) {
      var username = '[${message.source}] ${message.username}';

      trace('$username: ${message.text}');


      if (config.votes1.indexOf(username) != -1 || config.votes2.indexOf(username) != -1) {
        return;
      }

      var key = null;
      if (message.text.startsWith(config.key1)) {
        key = config.key1;
        config.votes1.push(username);
      }
      if (message.text.startsWith(config.key2)) {
        key = config.key2;
        config.votes2.push(username);
      }

      if (key != null) {
        app.socketServer.broadcast(haxe.Json.stringify({
          action: 'vote',
          key: key,
          username: username,
          config: config
        }));
        trace(config);
      }
    });

    app.socketServer.on('connection', function (client) {
      client.send(haxe.Json.stringify({
        action: 'init',
        key: null,
        username: null,
        config: config
      }));
    });

    app.ui.on('updatePolls', function (data) {

    });

  }

}