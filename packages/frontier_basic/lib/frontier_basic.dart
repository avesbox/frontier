library frontier_basic;

import 'dart:convert';

import 'package:frontier_strategy/frontier_strategy.dart';

final class BasicAuthOptions extends StrategyOptions {
  /// The header to look for in the request
  ///
  /// By default this is set to 'Authorization', but can be changed
  final String header;

  /// A fallback header to use if the header is not found
  ///
  /// By default this is set to 'Proxy-Authorization', but can be changed
  final String proxyHeader;

  /// Creates a new BasicAuthOptions
  BasicAuthOptions({
    this.header = 'Authorization',
    this.proxyHeader = 'Proxy-Authorization',
  });
}

/// The credentials gotten from the header
final class Credentials {
  /// The username
  final String username;

  /// The password
  final String password;

  /// Creates a new Credentials
  Credentials({required this.username, required this.password});

  @override
  bool operator ==(Object other) {
    return other is Credentials &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}

/// The strategy for basic authentication
class BasicAuthStrategy extends Strategy<BasicAuthOptions> {
  /// Creates a new BasicAuthStrategy
  BasicAuthStrategy(super.options, super.callback);

  @override
  String get name => 'BasicAuthentication';

  @override
  Future<void> authenticate(StrategyRequest request) async {
    Credentials? credentials;
    if (request.headers.containsKey(options.header)) {
      credentials = _decode(request.headers[options.header]!);
    } else if (request.headers.containsKey(options.proxyHeader)) {
      credentials = _decode(request.headers[options.proxyHeader]!);
    }
    if (credentials != null) {
      callback.call(options, credentials, done);
      return;
    }
    done(credentials);
  }

  Credentials? _decode(String value) {
    final decoded = utf8.decode(base64.decode(value));
    final parts = decoded.split(':');
    if (parts.length != 2) {
      return null;
    }
    return Credentials(username: parts[0], password: parts[1]);
  }
}
