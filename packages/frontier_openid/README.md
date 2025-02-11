![Frontier Banner](https://github.com/francescovallone/frontier/raw/main/assets/github-header.png)

# Frontier OpenID

Frontier OpenID is the strategy that provides OpenID Connect authentication for Frontier.

[Get Started](https://frontier.avesbox.com/openid.html) | [Pub.dev](https://pub.dev/packages/frontier_openid)

## Why Frontier OpenID?

Frontier OpenID is a simple strategy that provides OpenID Connect authentication. It is designed to be easy to use and to integrate with your app.

## Installation

Use the following to add the package to your `pubspec.yaml` file:

```bash	
dart pub add frontier_openid
```

## Usage

```dart
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
```

## License

Frontier OpenID is licensed under the MIT License.
