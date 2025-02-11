import 'dart:async';

/// Base class to extend for creating a new strategy
abstract class Strategy<T extends StrategyOptions> {
  /// The options for the strategy
  final T options;

  /// The callback to call when the strategy is done
  final StrategyCallback<T, Object> callback;

  /// Creates a new [Strategy]
  Strategy(
    this.options,
    this.callback,
  );

  Completer _callback = Completer<Object?>();

  /// The future of the strategy
  Future<Object?> get future => _callback.future;

  /// The callback to call when the strategy is done
  void Function(Object? result) get done => _callback.complete;

  /// Reset the strategy
  void reset() {
    _callback = Completer<Object?>();
  }

  /// Name of the strategy
  String get name;

  /// Authenticate the request
  Future<void> authenticate(StrategyRequest request);
}

/// Type definition for a strategy callback
typedef StrategyCallback<T, I> = Future<void> Function(
    T strategyOptions, I? data, void Function(Object? result) done);

/// Base class to extend for creating options for a strategy
abstract class StrategyOptions {}

/// The [StrategyRequest] class represents a request that is passed to a strategy
///
/// It is useful to have a common interface for all strategies to use
final class StrategyRequest {
  /// The headers of the request
  final Map<String, String> headers;

  /// The query parameters of the request
  final Map<String, String> query;

  /// The body of the request
  final dynamic body;

  /// The cookies of the request
  final Map<String, String> cookies;

  /// Creates a new [StrategyRequest]
  const StrategyRequest({
    this.headers = const {},
    this.query = const {},
    this.body,
    this.cookies = const {},
  });
}
