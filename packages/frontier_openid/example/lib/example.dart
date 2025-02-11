import 'dart:io';

import 'package:frontier/frontier.dart';
import 'package:frontier_openid/frontier_openid.dart';

void main() {
  final frontier = Frontier();

  frontier.use(OpenIdStrategy(
    OpenIdStrategyOptions(
      issuer: Issuer.google,
      clientId: 'client-id',
    ),
    (options, result, done) async {
      done((result as OpenIdResponse).userInfo.name != null);
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
        'jwt',
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
