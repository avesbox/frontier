library frontier_jwt;

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontier_strategy/frontier_strategy.dart';

class JwtStrategy extends Strategy<JwtStrategyOptions, String> {

  JwtStrategy(super.options, super.callback);

  @override
  String get name => 'jwt';

  @override
  Future<void> authenticate(String? data) async {
    if(data == null) {
      done.complete(null);
      return;
    }
    try {
      final jwt = JWT.verify(
        data, 
        options.secret,
        checkNotBefore: options.checkNotBefore,
        checkExpiresIn: options.checkExpiresIn,
        checkHeaderType: options.checkHeaderType,
        issuer: options.issuer,
        subject: options.subject,
        audience: options.audience,
        jwtId: options.jwtId,
        issueAt: options.issueAt
      );
      callback.call(options, jwt, done.complete);
    } catch(e) {
      done.complete(e);
    }
  }

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

  JwtStrategyOptions(
    this.secret,{
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
