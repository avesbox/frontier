library frontier_strategy;

/// Base class to extend for creating a new strategy
abstract interface class Strategy<T extends StrategyOptions, R> {

  /// Name of the strategy
  String get name;

  /// Authenticate the request
  Future<R> authenticate(T options);

}

abstract class StrategyOptions {}
