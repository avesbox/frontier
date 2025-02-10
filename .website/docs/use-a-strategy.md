# Use a Strategy

To use a strategy, you simply need to follow these steps:

```dart

import 'package:frontier/frontier.dart';

void main() async {
    final frontier = Frontier();
    frontier.use(MyStrategy(
        MyStrategyOptions(
            // Your strategy options
        ), 
        (options, result, done) async {
            // callback logic
        })
    );

    final result = await frontier.authenticate(
        'MyStrategy', // Strategy name
        StrategyRequest(
            // Add your request data here
        )
    );
}

```

As you can see in the example above you need to create a new instance of `Frontier` and then use the `use` method to add a new strategy. The `use` method receives a `Strategy` instance with the strategy options and a callback function that will be executed when that strategy is called. The callback function receives the strategy options, the result of the strategy and a `done` function that you need to call when the execution of the callback is done.

The `authenticate` method is used to call a strategy. It receives the strategy name and a `StrategyRequest` instance with the request data. The `authenticate` method returns a `Future` with the result of the strategy.

The `StrategyRequest` class is a simple class that has been added as a standard to pass the request data to the strategy this way it does not matter from which framework you are using Frontier, the request data will always be the same.
