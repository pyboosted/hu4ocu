package data;

import Formats;

class Polls implements async.Build {
  var config:PollsConfig;
  public function new() {

    config = {
      status: PollsStatuses.NotRunning,
      visual: PollsVisuals.Hidden,
      q1: 'Team 1', q2: 'Team 2',
      key1: '1', key2: '2',
      votes1: [], votes2: []
    };

    API.on('polls.vote', function (vote: PollsVote) {
      var voter = { source: vote.source, user: vote.user }
      if (vote.key == config.key1) {
        config.votes1.push(voter);
      }
      if (vote.key == config.key2) {
       config.votes2.push(voter); 
      }

      UI.update();
    });
  }

  @async public function update(_config: Dynamic):Void {

    [_] = API.async('polls.set', _config);

    config.q1 = _config.q1;
    config.q2 = _config.q2;
    config.key1 = _config.key1;
    config.key2 = _config.key2;

    UI.update();
  }

  @async public function start():Void {
    [_] = API.async('polls.start', null);
    config.status = PollsStatuses.Running;
    UI.update();
  }

  @async public function stop():Void {
    [_] = API.async('polls.stop', null);
    config.status = PollsStatuses.Stopped; 
    UI.update();
  }

  @async public function show():Void {
    [_] = API.async('polls.show', null);
    config.visual = PollsVisuals.Visible;
    UI.update();
  }

  @async public function hide():Void {
    [_] = API.async('polls.hide', null);
    config.visual = PollsVisuals.Hidden; 
    UI.update();
  }

  @async public function reset():Void {
    [_] = API.async('polls.reset', null);
    config = {
      status: PollsStatuses.NotRunning,
      visual: config.visual,
      q1: 'Team 1', q2: 'Team 2',
      key1: '1', key2: '2',
      votes1: [], votes2: []
    };
    UI.update();
  }

  public function get():PollsConfig {
    return config;
  }
}