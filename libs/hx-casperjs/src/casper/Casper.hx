package casper;

typedef CasperConfig = {
  verbose: Bool,
  logLevel: String,
  pageSettings: Dynamic
};

@:jsRequire('casper')
extern class Casper {

  public static function create(?config:CasperConfig):Casper;
  public static function selectXPath(selector: String):Dynamic;

  public function start(?url: String, ?callback: Void->Void):Void;
  public function then(fn: Void->Void):Void;
  public function thenOpen(url: String, fn: Void->Void):Void;
  public function run(?fn: Void->Void):Void;
  public function waitForSelector(selector: String, fn: Void->Void):Void;
  public function waitForSelectorTextChange(selector: String, fn: Void->Void):Void;
  public function echo(data: Dynamic):Void;
  public function evaluate(fn: Void->Dynamic):Dynamic;
  public function capture(path: String):Void;
  public function wait(timeout: Int):Void;
  public function exit():Void;
  public function viewport(w: Int, h:Int):Void;
  public function getTitle():String;
  public function exists(selector:String):Bool;
  public function userAgent(agent: String):Void;
}