package lib;

class StaticServer {

  public function new(path: String, ?port: Int = 8080) {

    var fileServer = new nodestatic.Server(path, { cache: 0 });
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
      }).resume();
    });

    httpServer.listen(port);

  }

}