package electron;

typedef WindowConfig = {
  width: Int,
  height: Int,
  ?frame: Bool
}

@:jsRequire('browser-window')
extern class BrowserWindow {

  public function new(windowConfig: Dynamic):Void;
  public function loadUrl(url: String):Void;
  public function openDevTools():Void;
  public function on(eventName:String, handler: Void->Void):Void;

}