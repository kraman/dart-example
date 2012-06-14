#import('dart:io');

send404(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.contentLength = 19;
  response.outputStream.writeString("404: File not found");
  response.outputStream.close();
}

startServer(String basePath) {
  var server = new HttpServer();
  var env = Platform.environment;
  var internal_ip = env['OPENSHIFT_INTERNAL_IP'];

  server.listen(internal_ip, 8080);
  server.defaultRequestHandler = (HttpRequest request, HttpResponse response) {
    var path = request.path == '/' ? '/index.html' : request.path;
    var file = new File('${basePath}${path}');
    var filePathFuture = file.fullPath();

    filePathFuture.handleException(onException(Object exception){
      send404(response);
      return true;
    });

    filePathFuture.then(onValue(fullPath) {
      if (!fullPath.startsWith(basePath)) {
        send404(response);
      } else {
        file.exists().then(
          onValue(found) {
            if (found) {
              file.length().then(onValue(length) {
                var fileStream = file.openInputStream();
                print("Serving " + fullPath + ". Content length: " + length);
                response.contentLength = length;
                fileStream.pipe(response.outputStream);
                response.outputStream.flush();
                response.outputStream.close();
              });
            } else {
              send404(response);
            }
          }
        );
      }
      return true;
     });
  };
}

main() {
  // Compute base path for the request based on the location of the
  // script and then start the server.
  File script = new File(new Options().script);
  script.directory().then((Directory d) {
    startServer(d.path);
  });
}