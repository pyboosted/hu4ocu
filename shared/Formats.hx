// ====== CHATS =======

@:enum abstract ChatProviders(String) {
  var Rutony = 'rutony';
  var Youtube = 'youtube';
  var Goodgame = 'goodgame';
  var Twitch = 'twitch';
  var Sc2tv = 'sc2tv';
}

@:enum abstract ChatProviderStatuses(String) {
  var Connected = 'connected';
  var Pending = 'pending';
  var Disconnected = 'disconnected';
}

@:enum abstract MessageSources(String) {
  var Youtube = 'youtube';
  var Goodgame = 'goodgame';
  var Twitch = 'twitch';
  var Sc2tv = 'sc2tv'; 
}

typedef ChatMessage = {
  source: MessageSources,
  text: String,
  username: String,
  ?link: String
}

// ====== POLLS =======

@:enum abstract PollsStatuses(String) {
  var NotRunning = 'not_running';
  var Running = 'running';
  var Stopped = 'stopped'; 
}

@:enum abstract PollsVisuals(String) {
  var Visible = 'visible';
  var Hidden = 'hidden';
}

typedef PollsVoter = {
  source: MessageSources,
  user: String
};

typedef PollsVote = {
  source: MessageSources,
  user: String,
  key: String
};

typedef PollsConfig = {
  status: PollsStatuses,
  visual: PollsVisuals,
  key1: String, key2: String,
  q1: String, q2: String,
  ?votes1: Array<PollsVoter>, 
  ?votes2: Array<PollsVoter>
}

// ====== WHEEL =======

@:enum abstract WheelStatuses(String) {
  var NotRunning = 'not_running';
  var Speeding = 'speeding';
  var Running = 'running';
  var Slowing = 'slowing';
  var Stopped = 'stopped';
}

typedef WheelConfig = {
  status: WheelStatuses,
  list: Array<String>,
  winner: Int
};