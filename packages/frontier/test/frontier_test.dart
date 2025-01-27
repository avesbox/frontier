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

class HeaderStrategy extends Strategy<HeaderOptions, Map<String, dynamic>> {

  HeaderStrategy(super.options, super.callback);

  @override
  String get name => 'Header';

  @override
  Future<void> authenticate(Map<String, dynamic> headers) async {
    callback.call(options, headers[options.key] == options.value, done.complete);
  }
  
}

void main() {
  group('$Frontier', () {
    test('should authenticate with HeaderStrategy', () async {
      final frontier = Frontier();
      frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin'), (options, result, done) async {
          done(result);
        }));
      final headers = <String, dynamic>{};
      headers['auth'] = 'admin';
      final value = await frontier.authenticate(
        'Header',
        headers,
      );
      expect(value, true);
    });

    test('should not authenticate with HeaderStrategy', () async {
      final frontier = Frontier();
      frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin'), (options, result, done) async {
        done(result);
      }));
      final headers = <String, dynamic>{};
      headers['auth'] = 'user';
      final authenticated = await frontier.authenticate('Header', headers);
      expect(authenticated, false);
    });
  });
}
