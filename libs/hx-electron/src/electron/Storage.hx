package electron;

@:jsRequire('electron-json-storage')
extern class Storage {
  public static function get(key: String):Dynamic;
  public static function set(key: String, data:Dynamic):Void;
  public static function has(key: String):Bool;
}