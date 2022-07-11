// Mocks generated by Mockito 5.2.0 from annotations
// in pluto_grid/test/src/manager/state/scroll_state_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pluto_grid/pluto_grid.dart' as _i2;
import 'package:rxdart/rxdart.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakePlutoGridStateManager_0 extends _i1.Fake
    implements _i2.PlutoGridStateManager {}

class _FakePublishSubject_1<T> extends _i1.Fake
    implements _i3.PublishSubject<T> {}

class _FakeStreamSubscription_2<T> extends _i1.Fake
    implements _i4.StreamSubscription<T> {}

/// A class which mocks [PlutoGridEventManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlutoGridEventManager extends _i1.Mock
    implements _i2.PlutoGridEventManager {
  @override
  _i2.PlutoGridStateManager get stateManager =>
      (super.noSuchMethod(Invocation.getter(#stateManager),
              returnValue: _FakePlutoGridStateManager_0())
          as _i2.PlutoGridStateManager);
  @override
  _i3.PublishSubject<_i2.PlutoGridEvent> get subject =>
      (super.noSuchMethod(Invocation.getter(#subject),
              returnValue: _FakePublishSubject_1<_i2.PlutoGridEvent>())
          as _i3.PublishSubject<_i2.PlutoGridEvent>);
  @override
  _i4.StreamSubscription<dynamic> get subscription =>
      (super.noSuchMethod(Invocation.getter(#subscription),
              returnValue: _FakeStreamSubscription_2<dynamic>())
          as _i4.StreamSubscription<dynamic>);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void init() => super.noSuchMethod(Invocation.method(#init, []),
      returnValueForMissingStub: null);
  @override
  void addEvent(_i2.PlutoGridEvent? event) =>
      super.noSuchMethod(Invocation.method(#addEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i4.StreamSubscription<_i2.PlutoGridEvent> listener(
          void Function(_i2.PlutoGridEvent)? onData) =>
      (super.noSuchMethod(Invocation.method(#listener, [onData]),
              returnValue: _FakeStreamSubscription_2<_i2.PlutoGridEvent>())
          as _i4.StreamSubscription<_i2.PlutoGridEvent>);
}