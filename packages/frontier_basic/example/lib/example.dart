import 'dart:io';

import 'package:frontier/frontier.dart';
import 'package:frontier_basic/frontier_basic.dart';

void main() {
  final frontier = Frontier();

  frontier.use(BasicAuthStrategy(
    BasicAuthOptions(
      header: 'Authorization',
    ),
    (options, credentials, done) async {
      done(credentials == Credentials(username: 'admin', password: 'admin'));
    },
  ));

  final server = HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  server.then((server) {
    server.listen((HttpRequest request) async {
      final headers = <String, String>{};
      request.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });
      final result = await frontier.authenticate(
        'BasicAuthentication',
        StrategyRequest(headers: headers),
      );
      if (result) {
        request.response.write('Authenticated');
      } else {
        request.response.statusCode = HttpStatus.unauthorized;
        request.response.write('Not Authenticated');
      }
    });
  });
}
