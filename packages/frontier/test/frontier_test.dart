import 'dart:async';

import 'package:frontier/frontier.dart';
import 'package:test/test.dart';

final class HeaderOptions extends StrategyOptions {
  final String key;
  final String value;

  HeaderOptions(
      {required this.key, required this.value});
}

class HeaderResult {
  final bool authenticated;

  HeaderResult({required this.authenticated});
}

class HeaderStrategy implements Strategy<HeaderOptions, Map<String, dynamic>, bool> {

  const HeaderStrategy(this.options);

  @override
  String get name => 'Header';

  @override
  Future<bool> authenticate(Map<String, dynamic> headers) async {
    return headers[options.key] == options.value;
  }
  
  @override
  final HeaderOptions options;
}

void main() {
  group('$Frontier', () {
    test('should authenticate with HeaderStrategy', () async {
      final frontier = Frontier();
      frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin')));
      final headers = <String, dynamic>{};
      headers['auth'] = 'admin';
      final value = await frontier.authenticate(
        'Header',
        headers,
        (options, result) async {
          return result;
        }
      );
      expect(value, true);
    });

    test('should not authenticate with HeaderStrategy', () async {
      final frontier = Frontier();
      frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin')));
      final headers = <String, dynamic>{};
      headers['auth'] = 'user';
      final authenticated = await frontier.authenticate('Header', headers, (options, result) async {
        return result;
      });
      expect(authenticated, false);
    });
  });
}
