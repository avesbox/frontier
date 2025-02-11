library frontier_jwt;

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontier_strategy/frontier_strategy.dart';

import 'extract_jwt.dart';

/// A class that represents a JWT strategy
class JwtStrategy extends Strategy<JwtStrategyOptions> {
  JwtStrategy(super.options, super.callback);

  @override
  String get name => 'jwt';

  @override
  Future<void> authenticate(StrategyRequest request) async {
    try {
      final jwtString = options.jwtFromRequest(request);
      if (jwtString == null) {
        return done(null);
      }
      final jwt = JWT.verify(jwtString, options.secret,
          checkNotBefore: options.checkNotBefore,
          checkExpiresIn: options.checkExpiresIn,
          checkHeaderType: options.checkHeaderType,
          issuer: options.issuer,
          subject: options.subject,
          audience: options.audience,
          jwtId: options.jwtId,
          issueAt: options.issueAt);
      callback.call(options, jwt, done);
    } catch (e) {
      done(e);
    }
  }
}

/// A class that represents the options for the JWT strategy
class JwtStrategyOptions extends StrategyOptions {
  /// The secret to use for verifying the JWT
  ///
  /// It must be one of the following:
  /// - SecretKey with HMAC algorithm
  /// - RSAPublicKey with RSA algorithm
  /// - ECPublicKey with ECDSA algorithm
  /// - EdDSAPublicKey with EdDSA algorithm
  final JWTKey secret;
  final ExtractJwtFunction jwtFromRequest;
  final bool checkNotBefore;
  final bool checkExpiresIn;
  final bool checkHeaderType;
  final Duration? issueAt;
  final Audience? audience;
  final String? subject;
  final String? issuer;
  final String? jwtId;

  /// Creates a new JwtStrategyOptions
  JwtStrategyOptions(this.secret,
      {required this.jwtFromRequest,
      this.checkNotBefore = true,
      this.checkExpiresIn = true,
      this.checkHeaderType = true,
      this.issueAt,
      this.audience,
      this.subject,
      this.issuer,
      this.jwtId});
}
