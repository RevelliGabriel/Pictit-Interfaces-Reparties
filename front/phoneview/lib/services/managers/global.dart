import 'package:phoneview/services/managers/connection_manager.dart';
import 'package:phoneview/services/managers/game_manager.dart';

import 'manager.dart';

/// Singleton manager that is accessible from everywhere
class Global {
  Map<dynamic, Manager> repository = {};

  Map<dynamic, Function> _factories = {
    GameManager: () => GameManager(),
    ConnectionManager: () => ConnectionManager()
  };

  static final Global _singleton = Global._internal();

  factory Global() => _singleton;

  Global._internal();

  /// summon the singleton [name]
  _summon(name) => repository[name] = _factories[name]();

  /// access the singleton [name] and if it's not summoned, it summon it
  fetch(name) =>
      repository.containsKey(name) ? repository[name] : _summon(name);

  /// to destroy the singleton [name]
  release(name) {
    Manager manager = repository[name];
    manager.dispose();
    repository.remove(name);
  }
}
