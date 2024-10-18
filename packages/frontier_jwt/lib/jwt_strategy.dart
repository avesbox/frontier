library frontier_jwt;

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontier_strategy/frontier_strategy.dart';

class JwtStrategy implements Strategy<JwtStrategyOptions, String, JWT> {

  const JwtStrategy(this.options);

  @override
  String get name => 'jwt';

  @override
  Future<JWT> authenticate(String token) async {
    return JWT.verify(
      token, 
      options.secret
    );
  }

  @override
  final JwtStrategyOptions options;

}

class JwtStrategyOptions extends StrategyOptions {
  /// The secret to use for verifying the JWT
  /// 
  /// It must be one of the following:
  /// - SecretKey with HMAC algorithm
  /// - RSAPublicKey with RSA algorithm
  /// - ECPublicKey with ECDSA algorithm
  /// - EdDSAPublicKey with EdDSA algorithm
  final JWTKey secret;
  final bool checkNotBefore;
  final bool checkExpiresIn;
  final bool checkHeaderType;
  final Duration? issueAt;
  final Audience? audience;
  final String? subject;
  final String? issuer;
  final String? jwtId;

  JwtStrategyOptions({
    required this.secret,
    this.checkNotBefore = true,
    this.checkExpiresIn = true,
    this.checkHeaderType = true,
    this.issueAt,
    this.audience,
    this.subject,
    this.issuer,
    this.jwtId
  });
}
