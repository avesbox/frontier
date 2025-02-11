export 'package:openid_client/openid_client.dart'
    show Issuer, TokenResponse, UserInfo;
import 'package:frontier_strategy/frontier_strategy.dart';
import 'package:openid_client/openid_client.dart';

/// The position to look for the refresh token
enum Position {
  query,
  body,
  header,
}

/// The options for the OpenIdStrategy
final class RefreshPosition {
  /// The position to look for the refresh token
  final Position position;

  /// The name of the refresh token
  final String name;

  /// Creates a new RefreshPosition
  RefreshPosition(this.position, this.name);
}

/// The options for the OpenIdStrategy
final class OpenIdStrategyOptions extends StrategyOptions {
  /// The header to look for in the request
  ///
  /// By default this is set to 'Authorization', but can be changed
  final String accessTokenHeader;

  /// The header to look for the id token
  final String? idTokenHeader;

  /// The position to look for the refresh token
  final RefreshPosition? refreshToken;

  /// The issuer of the token
  final Uri issuer;

  /// The client id
  final String clientId;

  /// The client secret
  final String? clientSecret;

  /// If set to true, the strategy will validate the claims of the token
  final bool validateClaims;

  /// If set to true, the strategy will validate the expiry of the token
  final bool validateExpiry;

  /// If set to true, the strategy will generate a logout URL
  final bool generateLoginUrl;

  /// If set to true, the strategy will force a refresh of the token
  final bool forceRefresh;

  /// Creates a new OpenIdStrategyOptions
  OpenIdStrategyOptions({
    required this.issuer,
    required this.clientId,
    this.clientSecret,
    this.accessTokenHeader = 'Authorization',
    this.idTokenHeader,
    this.validateClaims = true,
    this.validateExpiry = true,
    this.refreshToken,
    this.generateLoginUrl = false,
    this.forceRefresh = false,
  }) {
    if (refreshToken != null &&
        refreshToken?.position == Position.header &&
        refreshToken?.name == accessTokenHeader) {
      throw ArgumentError(
          'The refresh token header cannot be the same as the access token header');
    }
  }
}

/// A strategy for authenticating with an OpenId server
class OpenIdStrategy extends Strategy<OpenIdStrategyOptions> {
  /// Creates a new OpenIdStrategy
  OpenIdStrategy(super.options, super.callback);

  @override
  String get name => 'OpenIdAuthentication';

  @override
  Future<void> authenticate(StrategyRequest request) async {
    final issuer = await Issuer.discover(options.issuer);
    final client =
        Client(issuer, options.clientId, clientSecret: options.clientSecret);
    Credential credential = _decode(request, client);
    final violations = credential.validateToken(
      validateClaims: options.validateClaims,
      validateExpiry: options.validateExpiry,
    );
    final errors = <Exception>[];
    await for (var violation in violations) {
      errors.add(violation);
    }
    if (errors.isNotEmpty) {
      return done(errors);
    }
    Uri? url;
    if (options.generateLoginUrl) {
      url = credential.generateLogoutUrl();
    }
    final tokenResponse =
        await credential.getTokenResponse(options.forceRefresh);
    final userInfo = await credential.getUserInfo();
    callback.call(options, OpenIdResponse(userInfo, tokenResponse, url), done);
  }

  Credential _decode(StrategyRequest request, Client client) {
    final Map<String, String> json = {};
    if (options.idTokenHeader != null &&
        request.headers.containsKey(options.idTokenHeader)) {
      json['id_token'] = request.headers[options.idTokenHeader]!;
    }
    if (request.headers.containsKey(options.accessTokenHeader)) {
      json['access_token'] = request.headers[options.accessTokenHeader]!;
    }
    if (options.refreshToken != null) {
      switch (options.refreshToken!.position) {
        case Position.query:
          if (request.query.containsKey(options.refreshToken!.name)) {
            json['refresh_token'] = request.query[options.refreshToken!.name]!;
          }
          break;
        case Position.body:
          if (request.body is Map &&
              request.body.containsKey(options.refreshToken!.name)) {
            json['refresh_token'] = request.body[options.refreshToken!.name]!;
          }
          break;
        case Position.header:
          if (request.headers.containsKey(options.refreshToken!.name)) {
            json['refresh_token'] =
                request.headers[options.refreshToken!.name]!;
          }
          break;
      }
    }

    return client.createCredential(
      accessToken: json['access_token'],
      idToken: json['id_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

/// The response from the OpenIdStrategy
///
/// This contains the user information, the token response and the logout URL if it was generated
final class OpenIdResponse {
  /// The user information
  final UserInfo userInfo;

  /// The token response
  final TokenResponse tokenResponse;

  /// The logout URL if it was generated
  final Uri? logoutUrl;

  /// Creates a new OpenIdResponse
  OpenIdResponse(this.userInfo, this.tokenResponse, this.logoutUrl);
}
