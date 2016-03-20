package services;

import Formats;

using StringTools;

class Wheel extends Service {

  var config:Dynamic;

  function shuffle<T>(array: Array<T>) {

    var counter = array.length;
    var temp: T;
    var index: Int;

    // While there are elements in the array
    while (counter > 0) {
        // Pick a random index
        index = Math.floor(Math.random() * counter);

        // Decrease counter by 1
        counter--;

        // And swap the last element with it
        temp = array[counter];
        array[counter] = array[index];
        array[index] = temp;
    }

    return array;
  }

  function broadcast(action: String) {
    app.socketServer.broadcast(haxe.Json.stringify({
      action: action,
      config: config
    }));
    app.ui.notify(action, config);
  }

  public function new(app) {
    super(app);

    config = {
      status: NotRunning,
      visual: Hidden,
      list: [],
      keyword: null,
      winner: null
    };

    app.chats.onMessage(function (message) {

      if (config.keyword != null) {

        var username = '[${message.source}] ${message.username}';
        if (message.text.startsWith(config.keyword)) {
          config.list.push(username);          
        }

        broadcast('wheel.update');
      }

    });

    app.ui.when('wheel.get', function (_) {
      return config;
    });

    app.ui.when('wheel.keyword', function (keyword) {
      config.keyword = keyword;
      broadcast('wheel.keyword');
      return config;
    });

    app.ui.when('wheel.update', function (list:Array<String>) {
      var users = [];
      for (item in list) {
        if(item.trim().length > 0) {
          users.push(item);
        }
      }
      config.list = users;
      config.status = NotRunning;
      config.winner = null;
      broadcast('wheel.update');
      return config;
    });

    app.ui.when('wheel.shuffle', function (_) {
      config.list = shuffle(config.list);
      config.status = NotRunning;
      config.winner = null;
      broadcast('wheel.update');
      return config;
    });

    app.ui.when('wheel.start', function (_) {
      config.status = Speeding;
      broadcast('wheel.start');
      haxe.Timer.delay(function () {
        config.status = Running;
        broadcast('wheel.canstop');
      }, 6000);
      return config;
    });

    app.ui.when('wheel.stop', function (_) {
      var index = Math.floor(Math.random() * config.list.length);
      config.winner = index;
      config.status = Slowing;
      broadcast('wheel.stop');
      haxe.Timer.delay(function () {
        config.status = Stopped;
        broadcast('wheel.canreset');
      }, 11000);
      return config;
    });

    app.ui.when('wheel.show', function (_) {
      config.visual = Visible;
      broadcast('wheel.show');
      return config;
    });

    app.ui.when('wheel.hide', function (_) {
      config.visual = Hidden;
      broadcast('wheel.hide');
      return config;
    });


    app.socketServer.on('connection', function (client) {
      client.send(haxe.Json.stringify({
        action: 'wheel.init',
        config: config
      }));
    });
  }

}