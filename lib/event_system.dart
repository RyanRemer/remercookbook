import 'package:flutter/cupertino.dart';

class EventSystem extends InheritedWidget {
  final Map<Identifier, Reaction> reactionIdMap;
  final Map<Type, List<Reaction>> reactionEventMap;

  const EventSystem({
    Key? key,
    required Widget child,
    this.reactionIdMap = const {},
    this.reactionEventMap = const {},
  }) : super(
          key: key,
          child: child,
        );

  static EventSystem of(BuildContext context) {
    EventSystem? eventSystem =
        context.findAncestorWidgetOfExactType<EventSystem>();
    assert(() {
      if (eventSystem == null) {
        throw FlutterError(
            "EventSystem requested in a context that has no EventSystem ancestor,"
            "add an EventSystem to the desired location");
      }
      return true;
    }());
    return eventSystem!;
  }

  /// notifies all Event listeners 
  void notify(Event event) {
    List<Reaction> reactions = reactionEventMap[event.runtimeType] ?? [];
    for (var reaction in reactions) {
      reaction.onEvent(event);
    }
  }

  /// Registers the [onEvent] callback to be called any time that [notify]
  /// is called for this [EventSystem]. Use the [Identifier] to unregister
  /// a callback function.
  void register<T extends Event>(
    Identifier identifier,
    ValueChanged<T> onEvent,
  ) {
    Reaction reaction = Reaction<T>(identifier, onEvent);
    reactionIdMap[identifier] = reaction;
    reactionEventMap.putIfAbsent(T, () => []).add(reaction);
  }

  /// Unregisters a callback function so it is no longer called by this
  /// [EventSystem]. returns [true] if the identifier is found [false] if
  /// it is not found
  bool unregister<T extends Event>(Identifier identifier) {
    Reaction? reaction = reactionIdMap[identifier];
    if (reaction == null) {
      return false;
    }

    List<Reaction> reactions = reactionEventMap[T] ?? [];
    return reactions.remove(reaction);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class Identifier {}
class Event {}

class Reaction<T> {
  Identifier identifier;
  ValueChanged<T> onEvent;

  Reaction(this.identifier, this.onEvent);
}