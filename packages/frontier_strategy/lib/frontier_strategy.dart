library frontier_strategy;

/// Base class to extend for creating a new strategy
abstract interface class Strategy<T extends StrategyOptions> {

  /// Name of the strategy
  String get name;

  /// Authenticate the request
  Future<bool> authenticate(T options);

}

abstract class StrategyOptions {}