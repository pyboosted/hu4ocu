package ;

interface API {
  public function getVote():Vote;
  public function updateVote(vote: Vote);
  public function start():Void;
  public function stop():Void;
  public function show():Void;
  public function hide():Void;
}