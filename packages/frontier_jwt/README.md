![Frontier Banner](https://github.com/francescovallone/frontier/raw/main/assets/github-header.png)

# Frontier JWT

Frontier JWT is the strategy that provides Bearer JWT Token authentication for Frontier.

[Get Started](https://frontier.avesbox.com/jwt.html) | [Pub.dev](https://pub.dev/packages/frontier_basic)

## Why Frontier JWT?

Frontier JWT is a simple strategy that provides Bearer Token authentication. It is designed to be easy to use and to integrate with your app.

## Installation

Use the following to add the package to your `pubspec.yaml` file:

```bash	
dart pub add frontier_jwt
```

## Usage

```dart
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
```

## License

Frontier JWT is licensed under the MIT License.
