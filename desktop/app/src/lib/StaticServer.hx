package lib;

typedef StaticServerConfig = {
  path: String, 
  port: Int
};

class StaticServer {

  public function new(config: StaticServerConfig) {

    var fileServer = new nodestatic.Server(config.path, { cache: 0 });
    var httpServer = node.Http.createServer(function (req, res) {
      req.addListener('end', function () {
        fileServer.serve(req, res, function (err, result) {
          if (err != null) { // There was an error serving the file
            trace('Error serving ${req.url} ${err.message}');

            // Respond to the client
            res.writeHead(err.status, err.headers);
            res.end();
          }

        });
      });
      req.resume();
    });

    httpServer.listen(config.port);

  }

}