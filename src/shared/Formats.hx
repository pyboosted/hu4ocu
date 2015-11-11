package ;

enum VoteType {
  Dual;
  Multiple;
}

enum VoteStatus {
  Running;
  Stopped;
}

typedef User {
  var service: StreamingService;
  var name: String;
}

enum VoteVariant {
  var text: String;
  var key: String;
  var votes: Int;
  var users: Array<User>;
}

typedef Vote {
  var type: VoteType;
  var status: VoteStatus;
  var isHidden: Bool;
  var variants: Array<VoteVariant>;
}