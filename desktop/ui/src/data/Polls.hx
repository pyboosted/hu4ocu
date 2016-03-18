package data;

class Polls {
  var config:PollsConfig;
  public function new() {

    config = {
      status: PollsStatuses.NotRunning,
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
       config.votes1.push(voter); 
      }
    });
  }

  @async public function update(_config: PollsConfig):Void {
    [] = API.getAsync('polls.update', config);

    config.q1 = _config.q1;
    config.q2 = _config.q2;
    config.key1 = _config.key1;
    config.key2 = _config.key2;
  }

  @async public function start():Void {
    [] = API.getAsync('polls.start');
    config.status = PollsStatuses.Running;
  }

  @async public function stop():Void {
    [] = API.getAsync('polls.stop');
    config.status = PollsStatuses.Stopped; 
  }

  @async public function show():Void {
    [] = API.getAsync('polls.show');
    config.visual = PollsVisuals.Visible;
  }

  @async public function hide():Void {
    [] = API.getAsync('polls.hide');
    config.visual = PollsVisuals.Hidden; 
  }

  @async public function reset():Void {
    config = {
      status: PollsStatuses.NotRunning,
      q1: 'Team 1', q2: 'Team 2',
      key1: '1', key2: '2',
      votes1: [], votes2: []
    };
  }

  public function get():PollsConfig {
    return config;
  }
}