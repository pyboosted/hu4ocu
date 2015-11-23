package services;

import services.Service;
import haxe.EnumTools;
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

    app.ui.when('polls.get', function (_) {
      return this.getConfig();
    });

    app.ui.when('polls.start', function (_) {
      this.start();
      return this.getConfig();
    });

    app.ui.when('polls.stop', function (_) {
      this.stop();
      return this.getConfig();
    });

    app.ui.when('polls.hide', function (_) {
      this.hide();
      return this.getConfig();
    });

    app.ui.when('polls.show', function (_) {
      this.show();
      return this.getConfig();
    });

    app.ui.when('polls.reset', function (_) {
      this.reset();
      return this.getConfig();
    });

    app.ui.when('polls.set', function (config) {
      this.setConfig(config);
      return this.getConfig();
    });


    app.chats.onMessage(function (message) {

      if (config.status != Running) return;

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
          action: 'polls.vote',
          key: key,
          username: username,
          config: config
        }));
        trace(config);
      }
    });

    app.socketServer.on('connection', function (client) {
      client.send(haxe.Json.stringify({
        action: 'polls.init',
        key: null,
        username: null,
        config: config
      }));
    });

  
  }

  function broadcast(action: String) {
    app.socketServer.broadcast(haxe.Json.stringify({
      action: action,
      key: null,
      username: null,
      config: config
    }));
  }

  public function getConfig():PollsConfig {
    return config;
  }

  public function setConfig(data: Dynamic) {
    config.key1 = data.key1;
    config.key2 = data.key2;
    config.q1 = data.q1;
    config.q2 = data.q2;

    broadcast('polls.update');
  }

  public function show():Void {
    config.visual = Visible;
    broadcast('polls.show');
  }

  public function hide():Void {
    config.visual = Hidden;
    broadcast('polls.hide');
  }

  public function start():Void {
    config.status = Running;
    broadcast('polls.start');
  }

  public function stop():Void {
    config.status = Stopped;
    broadcast('polls.stop');
  }

  public function reset():Void {
    config.status = NotRunning;
    config.votes1 = [];
    config.votes2 = [];
    broadcast('polls.update');
  }

}