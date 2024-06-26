import 'package:frontier/frontier.dart';
import 'package:test/test.dart';

final class HeaderOptions extends StrategyOptions {

  final String key;
  final String value;
  final Map<String, dynamic> headers;

  HeaderOptions({
    required this.key,
    required this.value,
    required this.headers
  });

}

class HeaderStrategy implements Strategy<HeaderOptions> {

  @override
  String get name => 'Header';

  @override
  Future<bool> authenticate(HeaderOptions options) async {
    return options.headers[options.key] == options.value;
  }
  
}

void main() {
  group(
    '$Frontier',
    () {
      test('should authenticate with HeaderStrategy', () async {
        final frontier = Frontier();
        frontier.use(HeaderStrategy());
        final headers = <String, dynamic>{};
        headers['auth'] = 'admin';
        final authenticated = await frontier.authenticate(
          HeaderOptions(key: 'auth', value: 'admin', headers: headers),
        );
        expect(authenticated, true);
      });

      test('should not authenticate with HeaderStrategy', () async {
        final frontier = Frontier();
        frontier.use(HeaderStrategy());
        final headers = <String, dynamic>{};
        headers['auth'] = 'user';
        final authenticated = await frontier.authenticate(
          HeaderOptions(key: 'auth', value: 'admin', headers: headers),
        );
        expect(authenticated, false);
      });
    }
  );
}
