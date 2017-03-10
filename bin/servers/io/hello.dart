import 'dart:io';
import 'dart:isolate';

main(args, [SendPort sendPort]) async {
  var port = 0;
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port);
  print('Now listening at http://localhost:${server.port}');

  await for (var request in server) {
    var res = request.response;

    // Send some HTML
    res
      ..headers.contentType = ContentType.HTML
      ..write('''
    <!DOCTYPE html>
    <html>
      <head>
        <title>Hello World</title>
      </head>
      <body>
        <h1>Hello World</h1>
        <p>Welcome to `dart:io`.
      </body>
    </html>
    ''');

    await res.close();
  }

  sendPort?.send([server.address.address, server.port]);
}
