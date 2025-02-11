import 'dart:io';

import 'package:frontier/frontier.dart';
import 'package:frontier_jwt/frontier_jwt.dart';

void main() {
  final frontier = Frontier();

  frontier.use(JwtStrategy(
    JwtStrategyOptions(
      SecretKey('secret'),
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    ),
    (options, jwt, done) async {
      done(jwt != null);
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
