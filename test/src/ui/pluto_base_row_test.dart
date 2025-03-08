import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';
import 'package:rxdart/rxdart.dart';

import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';
import '../../mock/shared_mocks.mocks.dart';

void main() {
  late MockPlutoGridStateManager stateManager;
  PublishSubject<PlutoNotifierEvent> streamNotifier;
  List<PlutoColumn> columns;
  List<PlutoRow> rows;
  final resizingNotifier = ChangeNotifier();

  setUp(() {
    const configuration = PlutoGridConfiguration();
    stateManager = MockPlutoGridStateManager();
    streamNotifier = PublishSubject<PlutoNotifierEvent>();
    when(stateManager.streamNotifier).thenAnswer((_) => streamNotifier);
    when(stateManager.resizingChangeNotifier).thenReturn(resizingNotifier);
    when(stateManager.configuration).thenReturn(configuration);
    when(stateManager.style).thenReturn(configuration.style);
    when(stateManager.localeText).thenReturn(const PlutoGridLocaleText());
    when(stateManager.rowHeight).thenReturn(45);
    when(stateManager.isSelecting).thenReturn(true);
    when(stateManager.hasCurrentSelectingPosition).thenReturn(true);
    when(stateManager.isEditing).thenReturn(true);
    when(stateManager.selectingMode).thenReturn(PlutoGridSelectingMode.cell);
    when(stateManager.hasFocus).thenReturn(true);
    when(stateManager.canRowDrag).thenReturn(true);
    when(stateManager.showFrozenColumn).thenReturn(false);
    when(stateManager.enabledRowGroups).thenReturn(false);
    when(stateManager.rowGroupDelegate).thenReturn(null);
  });

  buildRowWidget({
    int rowIdx = 0,
    bool checked = false,
    bool isDraggingRow = false,
    bool isDragTarget = false,
    bool isTopDragTarget = false,
    bool isBottomDragTarget = false,
    List<PlutoRow> dragRows = const [],
    bool isSelectedRow = false,
    bool isCurrentCell = false,
    bool isSelectedCell = false,
  }) {
    return PlutoWidgetTestHelper(
      'build row widget.',
      (tester) async {
        when(stateManager.isDraggingRow).thenReturn(isDraggingRow);
        when(stateManager.isRowIdxDragTarget(any)).thenReturn(isDragTarget);
        when(stateManager.isRowIdxTopDragTarget(any))
            .thenReturn(isTopDragTarget);
        when(stateManager.isRowIdxBottomDragTarget(any))
            .thenReturn(isBottomDragTarget);
        when(stateManager.dragRows).thenReturn(dragRows);
        when(stateManager.isSelectedRow(any)).thenReturn(isSelectedRow);
        when(stateManager.isCurrentCell(any)).thenReturn(isCurrentCell);
        when(stateManager.isSelectedCell(any, any, any))
            .thenReturn(isSelectedCell);

        // given
        columns = ColumnHelper.textColumn('header', count: 3);
        rows = RowHelper.count(10, columns);

        when(stateManager.columns).thenReturn(columns);

        final row = rows[rowIdx];

        if (checked) {
          row.setChecked(true);
        }

        // when
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoBaseRow(
                rowIdx: rowIdx,
                row: row,
                columns: columns,
                stateManager: stateManager,
              ),
            ),
          ),
        );
      },
    );
  }

  buildRowWidget(checked: true).test(
    'When row is checked, rowColor should have alphaBlend applied',
    (tester) async {
      final rowContainerWidget = find
          .byType(DecoratedBox)
          .first
          .evaluate()
          .first
          .widget as DecoratedBox;

      final rowContainerDecoration =
          rowContainerWidget.decoration as BoxDecoration;

      expect(
        rowContainerDecoration.color,
        Color.alphaBlend(const Color(0x11757575), Colors.white),
      );
    },
  );

  buildRowWidget(checked: false).test(
    'When row is not checked, rowColor should not have alphaBlend applied',
    (tester) async {
      final rowContainerWidget = find
          .byType(DecoratedBox)
          .first
          .evaluate()
          .first
          .widget as DecoratedBox;

      final rowContainerDecoration =
          rowContainerWidget.decoration as BoxDecoration;

      expect(rowContainerDecoration.color, Colors.white);
    },
  );

  buildRowWidget(
    isDraggingRow: true,
    isDragTarget: true,
    isTopDragTarget: true,
  ).test(
    'When isDragTarget and isTopDragTarget are true, border top should be set',
    (tester) async {
      final rowContainerWidget = find
          .byType(DecoratedBox)
          .first
          .evaluate()
          .first
          .widget as DecoratedBox;

      final rowContainerDecoration =
          rowContainerWidget.decoration as BoxDecoration;

      expect(
        rowContainerDecoration.border!.top.width,
        PlutoGridSettings.rowBorderWidth,
      );
    },
  );

  buildRowWidget(
    isDragTarget: true,
    isBottomDragTarget: true,
  ).test(
    'When isDragTarget and isBottomDragTarget are true, border bottom should be set',
    (tester) async {
      final rowContainerWidget = find
          .byType(DecoratedBox)
          .first
          .evaluate()
          .first
          .widget as DecoratedBox;

      final rowContainerDecoration =
          rowContainerWidget.decoration as BoxDecoration;

      expect(
        rowContainerDecoration.border!.bottom.width,
        PlutoGridSettings.rowBorderWidth,
      );
    },
  );
}
