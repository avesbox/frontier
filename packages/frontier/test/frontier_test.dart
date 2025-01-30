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

class HeaderStrategy extends Strategy<HeaderOptions> {

  HeaderStrategy(super.options, super.callback);

  @override
  String get name => 'Header';

  @override
  Future<void> authenticate(StrategyRequest request) async {
    callback.call(options, request.headers[options.key] == options.value, done.complete);
  }
  
}

void main() {
  group('$Frontier', () {
    test('should authenticate with HeaderStrategy', () async {
      final frontier = Frontier();
      frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin'), (options, result, done) async {
          done(result);
        }));
      final headers = <String, String>{};
      headers['auth'] = 'admin';
      final value = await frontier.authenticate(
        'Header',
        StrategyRequest(headers: headers),
      );
      expect(value, true);
    });

    test('should not authenticate with HeaderStrategy', () async {
      final frontier = Frontier();
      frontier.use(HeaderStrategy(HeaderOptions(key: 'auth', value: 'admin'), (options, result, done) async {
        done(result);
      }));
      final headers = <String, String>{};
      headers['auth'] = 'user';
      final authenticated = await frontier.authenticate('Header', StrategyRequest(headers: headers));
      expect(authenticated, false);
    });
  });
}
