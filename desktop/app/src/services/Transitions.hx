package services;

typedef TransitionsConfig = {
  color: String
};


class Transitions extends Service {

  var config:Dynamic;

  function broadcast(action: String) {
    app.socketServer.broadcast(haxe.Json.stringify({
      action: action,
      config: config
    }));
  }

  public function new(app) {

    super(app);

    config = {
      color: 'rgba(0,0,0,0)'
    };

    app.ui.when('transitions.go', function (color) {
      broadcast('transitions.go');
      config.color = color;
      return config;
    });

    app.ui.when('transitions.get', function (color) {
      return config;
    });

    app.socketServer.on('connection', function (client) {
      client.send(haxe.Json.stringify({
        action: 'transitions.init',
        config: config
      }));
    });
  }

}