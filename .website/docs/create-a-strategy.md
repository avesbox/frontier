# Create a Strategy

Frontier provides a simple way to create a strategy. First of all you won't need to add `frontier` as a dependency to your project but instead you will use `frontier_strategy` as a dependency. To create a strategy you need to create a new class that extends `Strategy` and implement the `authenticate` method and the `name` getter. Below you can see an example of how to create a strategy:

```dart
import 'package:frontier_strategy/frontier_strategy.dart';

class MyStrategy extends Strategy {

  MyStrategy(MyStrategyOptions options, StrategyCallback<MyStrategyOptions, Object> callback) : super(options, callback);

  @override
  String get name => 'MyStrategy';

  @override
  Future<void> authenticate(StrategyRequest request) async {
    callback(options, 'Hello World!', done);
  }
}
```

::: warning
Remember to call the `callback` function when you are done with the strategy execution.
This will allow the user to use the strategy result to, for example, fetch the user data.
:::

In the example above you can see that the `MyStrategy` class extends `Strategy` and implements the `authenticate` method and the `name` getter. The `name` getter is used to define the strategy name and the `authenticate` method is used to execute the strategy logic. The `authenticate` method receives a `StrategyRequest` instance with the request data and returns a `Future`. The result of the strategy must be passed to the `callback` function that is received in the constructor of the `MyStrategy` class.

The `callback` function is a function that receives the strategy options, the result of the strategy and a `done` function that you need to call when the execution of the strategy is done. Its type signature is `StrategyCallback<T extends StrategyOptions, Object>` which translates in:

```dart

typedef StrategyCallback<T, I> = Future<void> Function(T strategyOptions, I? data, void Function(Object? result) done);

```

After creating the strategy you can use it in your project by following the [Use a Strategy](/docs/use-a-strategy) guide.
