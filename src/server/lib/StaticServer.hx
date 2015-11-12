package lib;

class StaticServer {

  public function new(path: String, ?port: Int = 8080) {

    var fileServer = new nodestatic.Server(path);
    var httpServer = node.Http.createServer(function (req, res) {
      req.addListener('end', function () {
        fileServer.serve(req, res);
      }).resume();
    });

    httpServer.listen(port);

  }

}