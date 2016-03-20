package data;

import Formats;

class Wheel implements async.Build {

  var config: WheelConfig;

  public function new() {
    config = {
      visual: Hidden,
      status: NotRunning,
      keyword: null,
      list: [],
      winner: null
    };

    API.on('wheel.canstop', function (_) {
      config.status = Running;
      UI.update();
    });

    API.on('wheel.canreset', function (_) {
      config.status = Stopped;
      API.async('wheel.get', null, function (err, cfg) {
        config.winner = cfg.winner;
        UI.update();
      });
    });
  }

  public function getConfig() {
    return config;
  }

  @async public function update(list:Array<String>):Void {
    [var cfg] = API.async('wheel.update', list);
    config.list = cfg.list;
  }

  @async public function shuffle():Void {
    [var cfg] = API.async('wheel.shuffle', null); 
    config.list = cfg.list;
  }

  @async public function start():Void {
    [var cfg] = API.async('wheel.start', null);
    config.status = cfg.status;
  }

  @async public function stop():Void {
    [var cfg] = API.async('wheel.stop', null);
    config.status = cfg.status;
  }

  @async public function show():Void {
    [var cfg] = API.async('wheel.show', null);
    config.visual = cfg.visual;
  }

  @async public function hide():Void {
    [var cfg] = API.async('wheel.hide', null);
    config.visual = cfg.visual;
  }

}