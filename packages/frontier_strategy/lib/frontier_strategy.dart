import 'dart:async';

/// Base class to extend for creating a new strategy
abstract class Strategy<T extends StrategyOptions> {

  final T options;
  final StrategyCallback<T, Object> callback;

  Strategy(
    this.options, 
    this.callback,
  );

  Completer done = Completer<Object?>();

  /// Name of the strategy
  String get name;

  /// Authenticate the request
  Future<void> authenticate(StrategyRequest data);
}

typedef StrategyCallback<T, I> = Future<void> Function(T strategyOptions, I? data, void Function(Object? result) done);

/// Base class to extend for creating options for a strategy
abstract class StrategyOptions {}

/// The [StrategyRequest] class represents a request that is passed to a strategy
/// 
/// It is useful to have a common interface for all strategies to use
final class StrategyRequest {

  final Map<String, String> headers;

  final Map<String, String> query;

  final dynamic body;

  final Map<String, String> cookies;

  const StrategyRequest({
    this.headers = const {},
    this.query = const {},
    this.body,
    this.cookies = const {},
  });

}