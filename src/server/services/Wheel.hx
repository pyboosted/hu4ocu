package services;

using StringTools;

@:enum abstract WheelStatus(String) {
  var NotRunning = 'not_running';
  var Running = 'running';
  var Stopped = 'stopped';
}

typedef WheelConfig = {
  status: WheelStatus,
  list: Array<String>,
  keyword: String,
  winner: String
};


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
  }

  public function new(app) {
    super(app);

    config = {
      status: NotRunning,
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

    app.ui.when('wheel.keyword', function (keyword) {
      config.keyword = keyword;
      broadcast('wheel.keyword');
      return config;
    });

    app.ui.when('wheel.update', function (list) {
      config.list = list;
      config.winner = null;
      broadcast('wheel.update');
      return config;
    });

    app.ui.when('wheel.shuffle', function (_) {
      config.list = shuffle(config.list);
      config.winner = null;
      broadcast('wheel.update');
      return config;
    });

    app.ui.when('wheel.roll', function (_) {
      var index = Math.floor(Math.random() * config.list.length);
      config.winner = config.list[index];
      broadcast('wheel.winner');
      return config;
    });
  }

}