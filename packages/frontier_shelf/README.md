![Frontier Banner](https://github.com/francescovallone/frontier/raw/main/assets/github-header.png)

# Frontier Shelf

Frontier She is the strategy that provides email/password authentication for Frontier.

[Get Started](https://frontier.avesbox.com/) | [Pub.dev](https://pub.dev/packages/frontier_shelf)

## Installation

Use the following to add the package to your `pubspec.yaml` file:

```bash	
dart pub add frontier_shelf
```

## Usage

```dart
import 'package:frontier/frontier.dart';
import 'package:frontier_shelf/frontier_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

final class HeaderOptions extends StrategyOptions {
  final String key;
  final String value;

  HeaderOptions({required this.key, required this.value});
}

class HeaderStrategy extends Strategy<HeaderOptions> {
  HeaderStrategy(super.options, super.callback);

  @override
  String get name => 'Header';

  @override
  Future<void> authenticate(StrategyRequest request) async {
    final value = request.headers[options.key] == options.value;
    callback.call(options, value, done);
  }
}

void main(List<String> arguments) async {
  frontier.use(
      HeaderStrategy(HeaderOptions(key: 'hello', value: 'world'),
          (options, result, done) async {
    done(result);
  }));
  var handler = const Pipeline()
      .addMiddleware(frontierMiddleware(
          'Header', (req) async => StrategyRequest(headers: req.headers)))
      .addHandler((req) => Response.ok('ok!'));

  await serve(handler, '0.0.0.0', 3000);
}
```

## License

Frontier JWT is licensed under the MIT License.