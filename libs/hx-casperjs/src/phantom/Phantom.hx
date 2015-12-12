package phantom;

typedef PhantomConfig = {
  verbose: Bool,
  logLevel: String,
  pageSettings: Dynamic
};

@:jsRequire('webpage')
extern class Phantom {

  public static function create(?config:PhantomConfig):Phantom;
  public static function selectXPath(selector: String):Dynamic;

  // public function start(?url: String, ?callback: Void->Void):Void;
  public function then(fn: Void->Void):Void;
  public function open(url: String, fn: Void->Void):Void;
  public function thenOpen(url: String, fn: Void->Void):Void;
  public function run(?fn: Void->Void):Void;
  public function waitForSelector(selector: String, fn: Void->Void):Void;
  public function waitForSelectorTextChange(selector: String, fn: Void->Void):Void;
  public function echo(data: Dynamic):Void;
  public function evaluate(fn: Void->Dynamic):Dynamic;
  public function render(path: String):Void;
  public function wait(timeout: Int):Void;
  public function exit():Void;
  public function viewport(w: Int, h:Int):Void;
  public function getTitle():String;
  public function exists(selector:String):Bool;
  public function userAgent(agent: String):Void;
}