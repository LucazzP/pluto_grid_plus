import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:rxdart/rxdart.dart';

/// 2021-11-19
/// Temporary code due to KeyEventResult.skipRemainingHandlers operation error
/// After issue resolution: Delete
///
/// Occurs only on desktop
/// When returning skipRemainingHandlers, the FocusScope callback in pluto_grid_plus.dart
/// is not called and key inputs should go to TextField, but
/// arrow keys, backspace, etc. are not input (characters are input normally)
/// https://github.com/flutter/flutter/issues/93873
class PlutoGridKeyEventResult {
  bool _skip = false;

  bool get isSkip => _skip;

  KeyEventResult skip(KeyEventResult result) {
    _skip = true;

    return result;
  }

  KeyEventResult consume(KeyEventResult result) {
    if (_skip) {
      _skip = false;

      return KeyEventResult.ignored;
    }

    return result;
  }
}

class PlutoGridKeyManager {
  PlutoGridStateManager stateManager;

  PlutoGridKeyEventResult eventResult = PlutoGridKeyEventResult();

  PlutoGridKeyManager({
    required this.stateManager,
  });

  final PublishSubject<PlutoKeyManagerEvent> _subject =
      PublishSubject<PlutoKeyManagerEvent>();

  PublishSubject<PlutoKeyManagerEvent> get subject => _subject;

  late final StreamSubscription _subscription;

  StreamSubscription get subscription => _subscription;

  void dispose() {
    _subscription.cancel();

    _subject.close();
  }

  void init() {
    final normalStream = _subject.stream.where((event) => !event.needsThrottle);

    final movingStream =
        _subject.stream.where((event) => event.needsThrottle).transform(
              ThrottleStreamTransformer(
                // ignore: void_checks
                (e) => TimerStream(e, const Duration(milliseconds: 1)),
              ),
            );

    _subscription = MergeStream([normalStream, movingStream]).listen(_handler);
  }

  void _handler(PlutoKeyManagerEvent keyEvent) {
    if (keyEvent.isKeyUpEvent) return;

    if (stateManager.configuration.shortcut.handle(
      keyEvent: keyEvent,
      stateManager: stateManager,
      state: HardwareKeyboard.instance,
    )) {
      return;
    }

    _handleDefaultActions(keyEvent);
  }

  void _handleDefaultActions(PlutoKeyManagerEvent keyEvent) {
    if (!keyEvent.isModifierPressed && keyEvent.isCharacter) {
      _handleCharacter(keyEvent);
      return;
    }
  }

  void _handleCharacter(PlutoKeyManagerEvent keyEvent) {
    if (stateManager.isEditing != true && stateManager.currentCell != null) {
      stateManager.setEditing(true);

      if (keyEvent.event.character == null) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (stateManager.textEditingController != null) {
          stateManager.textEditingController!.text = keyEvent.event.character!;
        }
      });
    }
  }
}
