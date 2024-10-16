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

/// Base class to extend for creating options for a strategy
abstract class StrategyOptions {}
