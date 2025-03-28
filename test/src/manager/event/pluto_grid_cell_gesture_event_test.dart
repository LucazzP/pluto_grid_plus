import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import '../../../helper/column_helper.dart';
import '../../../matcher/pluto_object_matcher.dart';
import '../../../mock/shared_mocks.mocks.dart';

void main() {
  late MockPlutoGridStateManager stateManager;
  late MockPlutoGridScrollController scroll;
  late MockLinkedScrollControllerGroup horizontalScroll;
  late MockScrollController horizontalScrollController;
  late MockLinkedScrollControllerGroup verticalScroll;
  late MockScrollController verticalScrollController;
  late MockPlutoGridEventManager eventManager;
  late PlutoGridKeyPressed keyPressed;

  eventBuilder({
    required PlutoGridGestureType gestureType,
    Offset? offset,
    PlutoCell? cell,
    PlutoColumn? column,
    int? rowIdx,
  }) =>
      PlutoGridCellGestureEvent(
        gestureType: gestureType,
        offset: offset ?? Offset.zero,
        cell: cell ?? PlutoCell(value: 'value'),
        column: column ??
            PlutoColumn(
              title: 'column',
              field: 'column',
              type: PlutoColumnType.text(),
            ),
        rowIdx: rowIdx ?? 0,
      );

  setUp(() {
    stateManager = MockPlutoGridStateManager();
    scroll = MockPlutoGridScrollController();
    horizontalScroll = MockLinkedScrollControllerGroup();
    horizontalScrollController = MockScrollController();
    verticalScroll = MockLinkedScrollControllerGroup();
    verticalScrollController = MockScrollController();
    eventManager = MockPlutoGridEventManager();
    keyPressed = MockPlutoGridKeyPressed();

    when(stateManager.eventManager).thenReturn(eventManager);
    when(stateManager.scroll).thenReturn(scroll);
    when(stateManager.isLTR).thenReturn(true);
    when(stateManager.keyPressed).thenReturn(keyPressed);
    when(scroll.horizontal).thenReturn(horizontalScroll);
    when(scroll.bodyRowsHorizontal).thenReturn(horizontalScrollController);
    when(scroll.vertical).thenReturn(verticalScroll);
    when(scroll.bodyRowsVertical).thenReturn(verticalScrollController);
    when(horizontalScrollController.offset).thenReturn(0.0);
    when(verticalScrollController.offset).thenReturn(0.0);
  });

  group('onTapUp', () {
    test(
      'When, '
      'hasFocus = false, '
      'isCurrentCell = true, '
      'Then, '
      'setKeepFocus(true) should be called, '
      'isCurrentCell is true, '
      'return should be called.',
      () {
        // given
        when(stateManager.hasFocus).thenReturn(false);
        when(stateManager.isCurrentCell(any)).thenReturn(true);
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(gestureType: PlutoGridGestureType.onTapUp);
        event.handler(stateManager);

        // then
        verify(stateManager.setKeepFocus(true)).called(1);
        // Methods that should not be called after return
        verifyNever(stateManager.setEditing(any));
        verifyNever(stateManager.setCurrentCell(any, any));
      },
    );

    test(
      'When, '
      'hasFocus = false, '
      'isCurrentCell = false, '
      'isSelectingInteraction = false, '
      'PlutoMode = normal, '
      'isEditing = true, '
      'Then, '
      'setKeepFocus(true) should be called, '
      'setCurrentCell should be called.',
      () {
        // given
        when(stateManager.hasFocus).thenReturn(false);
        when(stateManager.isCurrentCell(any)).thenReturn(false);
        when(stateManager.isSelectingInteraction()).thenReturn(false);
        when(stateManager.mode).thenReturn(PlutoGridMode.normal);
        when(stateManager.isEditing).thenReturn(true);
        clearInteractions(stateManager);

        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onTapUp,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(stateManager.setKeepFocus(true)).called(1);
        verify(stateManager.setCurrentCell(cell, rowIdx)).called(1);
        // Methods that should not be called after return
        verifyNever(stateManager.setEditing(any));
      },
    );

    test(
      'When, '
      'hasFocus = true, '
      'isCurrentCell = true, '
      'isSelectingInteraction = false, '
      'PlutoMode = normal, '
      'isEditing = false, '
      'Then, '
      'setEditing(true) should be called.',
      () {
        // given
        when(stateManager.hasFocus).thenReturn(true);
        when(stateManager.isCurrentCell(any)).thenReturn(true);
        when(stateManager.isSelectingInteraction()).thenReturn(false);
        when(stateManager.mode).thenReturn(PlutoGridMode.normal);
        when(stateManager.isEditing).thenReturn(false);
        clearInteractions(stateManager);

        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onTapUp,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(stateManager.setEditing(true)).called(1);
        // Methods that should not be called after return
        verifyNever(stateManager.setKeepFocus(true));
        verifyNever(stateManager.setCurrentCell(any, any));
      },
    );

    test(
      'When, '
      'hasFocus = true, '
      'isSelectingInteraction = true, '
      'keyPressed.shift = true, '
      'Then, '
      'setCurrentSelectingPosition should be called.',
      () {
        // given
        final column = ColumnHelper.textColumn('column').first;
        final cell = PlutoCell(value: 'value');
        const columnIdx = 1;
        const rowIdx = 1;

        when(stateManager.hasFocus).thenReturn(true);
        when(stateManager.isSelectingInteraction()).thenReturn(true);
        when(keyPressed.shift).thenReturn(true);
        when(stateManager.columnIndex(column)).thenReturn(columnIdx);
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onTapUp,
          cell: cell,
          rowIdx: rowIdx,
          column: column,
        );
        event.handler(stateManager);

        // then
        verify(
          stateManager.setCurrentSelectingPosition(
              cellPosition: const PlutoGridCellPosition(
            columnIdx: columnIdx,
            rowIdx: rowIdx,
          )),
        ).called(1);
        // Methods that should not be called after return
        verifyNever(stateManager.setKeepFocus(true));
        verifyNever(stateManager.toggleSelectingRow(any));
      },
    );

    test(
      'When, '
      'hasFocus = true, '
      'isSelectingInteraction = true, '
      'keyPressed.ctrl = true, '
      'Then, '
      'toggleSelectingRow should be called.',
      () {
        // given
        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        when(stateManager.hasFocus).thenReturn(true);
        when(stateManager.isSelectingInteraction()).thenReturn(true);
        when(keyPressed.ctrl).thenReturn(true);
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onTapUp,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(
          stateManager.toggleSelectingRow(rowIdx),
        ).called(1);
        // Methods that should not be called after return
        verifyNever(stateManager.setKeepFocus(true));
        verifyNever(stateManager.setCurrentSelectingPosition(
          cellPosition: anyNamed('cellPosition'),
        ));
      },
    );

    test(
      'When, '
      'hasFocus = true, '
      'isSelectingInteraction = false, '
      'PlutoMode = select, '
      'isCurrentCell = true, '
      'Then, '
      'handleOnSelected should be called.',
      () {
        // given
        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        when(stateManager.hasFocus).thenReturn(true);
        when(stateManager.isSelectingInteraction()).thenReturn(false);
        when(stateManager.mode).thenReturn(PlutoGridMode.select);
        when(stateManager.isCurrentCell(any)).thenReturn(true);
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onTapUp,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(stateManager.handleOnSelected()).called(1);
        // Methods that should not be called after return
        verifyNever(stateManager.setCurrentCell(any, any));
      },
    );

    test(
      'When, '
      'hasFocus = true, '
      'isSelectingInteraction = false, '
      'PlutoMode = select, '
      'isCurrentCell = false, '
      'Then, '
      'setCurrentCell should be called.',
      () {
        // given
        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        when(stateManager.hasFocus).thenReturn(true);
        when(stateManager.isSelectingInteraction()).thenReturn(false);
        when(stateManager.mode).thenReturn(PlutoGridMode.select);
        when(stateManager.isCurrentCell(any)).thenReturn(false);
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onTapUp,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(stateManager.setCurrentCell(cell, rowIdx));
        // Methods that should not be called after return
        verifyNever(stateManager.handleOnSelected());
      },
    );
  });

  group('onLongPressStart', () {
    test(
      'When, '
      'isCurrentCell = false, '
      'Then, '
      'setCurrentCell, setSelecting should be called.',
      () {
        // given
        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        when(stateManager.isCurrentCell(any)).thenReturn(false);
        when(stateManager.selectingMode).thenReturn(
          PlutoGridSelectingMode.cell,
        );
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onLongPressStart,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(stateManager.isCurrentCell(cell));
        verify(stateManager.setCurrentCell(cell, rowIdx, notify: false));
        verify(stateManager.setSelecting(true));
      },
    );

    test(
      'When, '
      'isCurrentCell = true, '
      'Then, '
      'setCurrentCell should not be called.',
      () {
        // given
        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        when(stateManager.isCurrentCell(any)).thenReturn(true);
        when(stateManager.selectingMode).thenReturn(
          PlutoGridSelectingMode.cell,
        );
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onLongPressStart,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verifyNever(stateManager.setCurrentCell(cell, rowIdx, notify: false));
      },
    );

    test(
      'When, '
      'isCurrentCell = false, '
      'selectingMode = Row, '
      'Then, '
      'toggleSelectingRow should be called.',
      () {
        // given
        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        when(stateManager.isCurrentCell(any)).thenReturn(false);
        when(stateManager.selectingMode).thenReturn(PlutoGridSelectingMode.row);
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onLongPressStart,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(stateManager.toggleSelectingRow(rowIdx));
      },
    );
  });

  group('onLongPressMoveUpdate', () {
    test(
      'When, '
      'isCurrentCell = false, '
      'selectingMode = Row, '
      'Then, '
      'setCurrentSelectingPositionWithOffset should be called.',
      () {
        // given
        const offset = Offset(2.0, 3.0);
        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        when(stateManager.isCurrentCell(any)).thenReturn(false);
        when(stateManager.selectingMode).thenReturn(PlutoGridSelectingMode.row);
        clearInteractions(stateManager);

        // when
        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onLongPressMoveUpdate,
          offset: offset,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(stateManager.setCurrentSelectingPositionWithOffset(offset));
        verify(eventManager.addEvent(argThat(
            PlutoObjectMatcher<PlutoGridScrollUpdateEvent>(rule: (event) {
          return event.offset == offset;
        }))));
      },
    );
  });

  group('onLongPressEnd', () {
    test(
      'When, '
      'isCurrentCell = true, '
      'Then, '
      'setSelecting(false) should be called.',
      () {
        // given
        final cell = PlutoCell(value: 'value');
        const rowIdx = 1;

        // when
        when(stateManager.isCurrentCell(any)).thenReturn(true);

        var event = eventBuilder(
          gestureType: PlutoGridGestureType.onLongPressEnd,
          cell: cell,
          rowIdx: rowIdx,
        );
        event.handler(stateManager);

        // then
        verify(stateManager.setSelecting(false));
      },
    );
  });
}
