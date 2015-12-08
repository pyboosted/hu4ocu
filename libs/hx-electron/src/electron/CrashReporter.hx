package electron;

@:jsRequire('electron', 'crashReporter')
extern class CrashReporter {
  public static function start():Void;
}