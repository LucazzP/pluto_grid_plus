import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

import '../../helper/column_helper.dart';
import '../../helper/row_helper.dart';
import '../../helper/test_helper_util.dart';

void main() {
  Widget buildGrid({
    required List<PlutoColumn> columns,
    required List<PlutoRow> rows,
    PlutoGridConfiguration configuration = const PlutoGridConfiguration(),
  }) {
    return MaterialApp(
      home: Material(
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          configuration: configuration,
        ),
      ),
    );
  }

  testWidgets(
    'When the window size is widened, the columns and cells should be displayed in the correct width.',
    (tester) async {
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 450,
        height: 600,
      );

      final columns = ColumnHelper.textColumn('column', count: 10);

      final rows = RowHelper.count(10, columns);

      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));

      final columnWidgets = find.byType(PlutoBaseColumn);

      final firstRowCells = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // visible columns
      expect(columnWidgets.evaluate().length, 3);
      expect(
        columnWidgets.at(0).hitTestable(at: Alignment.centerLeft),
        findsOneWidget,
      );
      expect(
        columnWidgets.at(1).hitTestable(at: Alignment.centerLeft),
        findsOneWidget,
      );
      expect(
        columnWidgets.at(2).hitTestable(at: Alignment.centerLeft),
        findsOneWidget,
      );

      // visible cells
      expect(firstRowCells.evaluate().length, 3);
      expect(
        firstRowCells.at(0).hitTestable(at: Alignment.centerLeft),
        findsOneWidget,
      );
      expect(
        firstRowCells.at(1).hitTestable(at: Alignment.centerLeft),
        findsOneWidget,
      );
      expect(
        firstRowCells.at(2).hitTestable(at: Alignment.centerLeft),
        findsOneWidget,
      );

      // resize
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 1050,
        height: 600,
      );

      final columnWidgetsAfterResize = find.byType(PlutoBaseColumn);

      final firstRowCellsAfterResize = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      expect(columnWidgetsAfterResize.evaluate().length, 6);
      expect(firstRowCellsAfterResize.evaluate().length, 6);
    },
  );

  testWidgets(
    'When the window size is narrowed, the columns and cells should be displayed in the correct width.',
    (tester) async {
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 1250,
        height: 600,
      );

      final columns = ColumnHelper.textColumn('column', count: 10);

      final rows = RowHelper.count(10, columns);

      await tester.pumpWidget(buildGrid(columns: columns, rows: rows));

      final columnWidgets = find.byType(PlutoBaseColumn);

      final firstRowCells = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      expect(columnWidgets.evaluate().length, 7);
      expect(firstRowCells.evaluate().length, 7);

      // resize
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 350,
        height: 600,
      );

      final columnWidgetsAfterResize = find.byType(PlutoBaseColumn);

      final firstRowCellsAfterResize = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      expect(columnWidgetsAfterResize.evaluate().length, 2);
      expect(firstRowCellsAfterResize.evaluate().length, 2);
    },
  );

  testWidgets(
    'When PlutoAutoSizeMode.equal is set, the columns and cells should be displayed in the correct width.',
    (tester) async {
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 550,
        height: 600,
      );

      final columns = ColumnHelper.textColumn('column', count: 10);

      final rows = RowHelper.count(10, columns);

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
          ),
        ),
      ));

      await tester.pump();

      final columnWidgets = find.byType(PlutoBaseColumn);

      final firstRowCells = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 550, the columns and cells should be displayed in the correct width.
      expect(columnWidgets.evaluate().length, 7);
      expect(firstRowCells.evaluate().length, 7);

      // resize
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 700,
        height: 600,
      );

      final columnWidgetsAfterResize = find.byType(PlutoBaseColumn);

      final firstRowCellsAfterResize = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 700, the columns and cells should be displayed in the correct width.
      expect(columnWidgetsAfterResize.evaluate().length, 9);
      expect(firstRowCellsAfterResize.evaluate().length, 9);
    },
  );

  testWidgets(
    'When PlutoAutoSizeMode.equal is set, the columns and cells should be displayed in the correct width.',
    (tester) async {
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 550,
        height: 600,
      );

      final columns = ColumnHelper.textColumn('column', count: 10);

      final rows = RowHelper.count(10, columns);

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
          ),
        ),
      ));

      await tester.pump();

      final columnWidgets = find.byType(PlutoBaseColumn);

      final firstRowCells = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 550, the columns and cells should be displayed in the correct width.
      expect(columnWidgets.evaluate().length, 7);
      expect(firstRowCells.evaluate().length, 7);

      // resize
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 1000,
        height: 600,
      );

      final columnWidgetsAfterResize = find.byType(PlutoBaseColumn);

      final firstRowCellsAfterResize = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 1,000, the columns and cells should be displayed in the correct width.
      expect(columnWidgetsAfterResize.evaluate().length, 10);
      expect(firstRowCellsAfterResize.evaluate().length, 10);
    },
  );

  testWidgets(
    'When PlutoAutoSizeMode.equal is set, the columns and cells should be displayed in the correct width.',
    (tester) async {
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 1200,
        height: 600,
      );

      final columns = ColumnHelper.textColumn('column', count: 10);

      final rows = RowHelper.count(10, columns);

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.equal,
          ),
        ),
      ));

      await tester.pump();

      final columnWidgets = find.byType(PlutoBaseColumn);

      final firstRowCells = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 1200, the columns and cells should be displayed in the correct width.
      expect(columnWidgets.evaluate().length, 10);
      expect(firstRowCells.evaluate().length, 10);

      // resize
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 360,
        height: 600,
      );

      final columnWidgetsAfterResize = find.byType(PlutoBaseColumn);

      final firstRowCellsAfterResize = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 360, the columns and cells should be displayed in the correct width.
      expect(columnWidgetsAfterResize.evaluate().length, 5);
      expect(firstRowCellsAfterResize.evaluate().length, 5);
    },
  );

  testWidgets(
    'When PlutoAutoSizeMode.scale is set, the columns and cells should be displayed in the correct width.',
    (tester) async {
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 550,
        height: 600,
      );

      final columns = ColumnHelper.textColumn('column', count: 10);

      final rows = RowHelper.count(10, columns);

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.scale,
          ),
        ),
      ));

      await tester.pump();

      final columnWidgets = find.byType(PlutoBaseColumn);

      final firstRowCells = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 550, the columns and cells should be displayed in the correct width.
      expect(columnWidgets.evaluate().length, 7);
      expect(firstRowCells.evaluate().length, 7);

      // resize
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 700,
        height: 600,
      );

      final columnWidgetsAfterResize = find.byType(PlutoBaseColumn);

      final firstRowCellsAfterResize = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 700, the columns and cells should be displayed in the correct width.
      expect(columnWidgetsAfterResize.evaluate().length, 9);
      expect(firstRowCellsAfterResize.evaluate().length, 9);
    },
  );

  testWidgets(
    'When PlutoAutoSizeMode.scale is set, the columns and cells should be displayed in the correct width.',
    (tester) async {
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 550,
        height: 600,
      );

      final columns = ColumnHelper.textColumn('column', count: 10);

      final rows = RowHelper.count(10, columns);

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.scale,
          ),
        ),
      ));

      await tester.pump();

      final columnWidgets = find.byType(PlutoBaseColumn);

      final firstRowCells = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 550, the columns and cells should be displayed in the correct width.
      expect(columnWidgets.evaluate().length, 7);
      expect(firstRowCells.evaluate().length, 7);

      // resize
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 1000,
        height: 600,
      );

      final columnWidgetsAfterResize = find.byType(PlutoBaseColumn);

      final firstRowCellsAfterResize = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 1000, the columns and cells should be displayed in the correct width.
      expect(columnWidgetsAfterResize.evaluate().length, 10);
      expect(firstRowCellsAfterResize.evaluate().length, 10);
    },
  );

  testWidgets(
    'When PlutoAutoSizeMode.scale is set, the columns and cells should be displayed in the correct width.',
    (tester) async {
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 1200,
        height: 600,
      );

      final columns = ColumnHelper.textColumn('column', count: 10);

      final rows = RowHelper.count(10, columns);

      await tester.pumpWidget(buildGrid(
        columns: columns,
        rows: rows,
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.scale,
          ),
        ),
      ));

      await tester.pump();

      final columnWidgets = find.byType(PlutoBaseColumn);

      final firstRowCells = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 1200, the columns and cells should be displayed in the correct width.
      expect(columnWidgets.evaluate().length, 10);
      expect(firstRowCells.evaluate().length, 10);

      // resize
      await TestHelperUtil.changeWidth(
        tester: tester,
        width: 360,
        height: 600,
      );

      final columnWidgetsAfterResize = find.byType(PlutoBaseColumn);

      final firstRowCellsAfterResize = find.descendant(
        of: find.byType(PlutoBaseRow).first,
        matching: find.byType(PlutoBaseCell),
      );

      // When the width is 360, the columns and cells should be displayed in the correct width.
      expect(columnWidgetsAfterResize.evaluate().length, 5);
      expect(firstRowCellsAfterResize.evaluate().length, 5);
    },
  );
}
