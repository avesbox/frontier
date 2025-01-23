library frontier_strategy;

/// Base class to extend for creating a new strategy
abstract interface class Strategy<T extends StrategyOptions, I, R> {

  final T options;

  Strategy(this.options);

  /// Name of the strategy
  String get name;

  /// Authenticate the request
  Future<R> authenticate(I data);
}

typedef StrategyCallback<T, I> = Future<dynamic> Function(T strategyOptions, I? data);

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