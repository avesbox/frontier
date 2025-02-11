![Frontier Banner](https://github.com/francescovallone/frontier/raw/main/assets/github-header.png)

# Frontier Basic

Frontier Basic is the strategy that provides email/password authentication for Frontier.

[Get Started](https://frontier.avesbox.com/basic.html) | [Pub.dev](https://pub.dev/packages/frontier_basic)

## Why Frontier Basic?

Frontier Basic is a simple strategy that provides email/password authentication. It is designed to be easy to use and to integrate with your app.

## Installation

Add the following to your `pubspec.yaml` file:

```bash
dart pub add frontier_basic
```

## Usage

```dart
import 'dart:io';

import 'package:frontier/frontier.dart';
import 'package:frontier_basic/frontier_basic.dart';

void main() {
  final frontier = Frontier();

  frontier.use(
    BasicAuthStrategy(
      BasicAuthOptions(
        header: 'Authorization',
      ),
      (options, credentials, done) async {
        done(credentials == Credentials(username: 'admin', password: 'admin'));
      },
    )
  );

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
```

## License

Frontier Basic is released under the MIT License. See [LICENSE](https://github.com/avesbox/frontier/blob/main/LICENSE)
