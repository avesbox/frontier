library jwt_strategy;

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontier_strategy/frontier_strategy.dart';

class JwtStrategy implements Strategy<JwtStrategyOptions, String, JWT> {

  const JwtStrategy(this.options);

  @override
  String get name => 'jwt';

  @override
  Future<JWT> authenticate(String token) async {
    JWT.verify(token, key);
  }

  @override
  final JwtStrategyOptions options;

}

class JwtStrategyOptions extends StrategyOptions {
  final SecretKey? secret;

  JwtStrategyOptions({required this.secret});
}
