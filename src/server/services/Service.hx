package services;

class Service {

  var ui: UI;
  var socket: ws.Server;
  public function new(app: Server) {
    ui = app.getUI();
  }

}