import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

import '../../../helper/pluto_widget_test_helper.dart';
import '../../../helper/row_helper.dart';
import '../../../mock/shared_mocks.mocks.dart';

void main() {
  late MockPlutoGridStateManager stateManager;

  setUp(() {
    stateManager = MockPlutoGridStateManager();
    when(stateManager.configuration).thenReturn(
      const PlutoGridConfiguration(),
    );
    when(stateManager.keyPressed).thenReturn(PlutoGridKeyPressed());
    when(stateManager.columnHeight).thenReturn(
      stateManager.configuration.style.columnHeight,
    );
    when(stateManager.rowHeight).thenReturn(
      stateManager.configuration.style.rowHeight,
    );
    when(stateManager.headerHeight).thenReturn(
      stateManager.configuration.style.columnHeight,
    );
    when(stateManager.rowTotalHeight).thenReturn(
      RowHelper.resolveRowTotalHeight(
        stateManager.configuration.style.rowHeight,
      ),
    );
    when(stateManager.localeText).thenReturn(const PlutoGridLocaleText());
    when(stateManager.keepFocus).thenReturn(true);
    when(stateManager.hasFocus).thenReturn(true);
  });

  group('Suffix icon rendering', () {
    final PlutoCell cell = PlutoCell(value: '2020-01-01');

    final PlutoRow row = PlutoRow(
      cells: {
        'column_field_name': cell,
      },
    );

    testWidgets('Default date icon should be rendered', (tester) async {
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.date(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PlutoDateCell(
              stateManager: stateManager,
              cell: cell,
              column: column,
              row: row,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.date_range), findsOneWidget);
    });

    testWidgets('Custom icon should be rendered', (tester) async {
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.date(
          popupIcon: Icons.add,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PlutoDateCell(
              stateManager: stateManager,
              cell: cell,
              column: column,
              row: row,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('When popupIcon is null, icon should not be rendered', (tester) async {
      final PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.date(
          popupIcon: null,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PlutoDateCell(
              stateManager: stateManager,
              cell: cell,
              column: column,
              row: row,
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });
  });

  group('Default date column', () {
    final PlutoColumn column = PlutoColumn(
      title: 'column title',
      field: 'column_field_name',
      type: PlutoColumnType.date(),
    );

    final PlutoCell cell = PlutoCell(value: '2020-01-01');

    final PlutoRow row = PlutoRow(
      cells: {
        'column_field_name': cell,
      },
    );

    final tapCell = PlutoWidgetTestHelper('Tap cell', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PlutoDateCell(
              stateManager: stateManager,
              cell: cell,
              column: column,
              row: row,
            ),
          ),
        ),
      );
    });

    tapCell.test('Should display 2020-01-01', (tester) async {
      expect(find.text('2020-01-01'), findsOneWidget);
    });

    tapCell.test('Tapping should open popup and display year, month, and day', (tester) async {
      await tester.tap(find.byType(TextField));

      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      expect(find.text('2020-01-01'), findsOneWidget);

      expect(find.text('2020-01'), findsOneWidget);
    });

    tapCell.test('Tapping should open popup and display day of week', (tester) async {
      await tester.tap(find.byType(TextField));

      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      expect(find.text('Su'), findsOneWidget);
      expect(find.text('Mo'), findsOneWidget);
      expect(find.text('Tu'), findsOneWidget);
      expect(find.text('We'), findsOneWidget);
      expect(find.text('Th'), findsOneWidget);
      expect(find.text('Fr'), findsOneWidget);
      expect(find.text('Sa'), findsOneWidget);
    });
  });

  group('Format MM/dd/yyyy', () {
    makeDateCell(String date) {
      PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.date(format: 'MM/dd/yyyy'),
      );

      PlutoCell cell = PlutoCell(value: date);

      final PlutoRow row = PlutoRow(
        cells: {
          'column_field_name': cell,
        },
      );

      return PlutoWidgetTestHelper('Create DateCell', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoDateCell(
                stateManager: stateManager,
                cell: cell,
                column: column,
                row: row,
              ),
            ),
          ),
        );
      });
    }

    makeDateCell('01/30/2020').test(
      'Should display 01/30/2020',
      (tester) async {
        expect(find.text('01/30/2020'), findsOneWidget);
      },
    );

    makeDateCell('06/15/2020').test(
      'Should display 06/15/2020',
      (tester) async {
        expect(find.text('06/15/2020'), findsOneWidget);
      },
    );

    makeDateCell('01/30/2020').test(
      'Tapping should open popup and display year, month, and day',
      (tester) async {
        await tester.tap(find.byType(TextField));

        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        expect(find.text('2020-01'), findsOneWidget);

        expect(find.text('01/30/2020'), findsOneWidget);
      },
    );

    makeDateCell('09/12/2020').test(
      'Tapping should open popup and display year, month, and day',
      (tester) async {
        await tester.tap(find.byType(TextField));

        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        expect(find.text('2020-09'), findsOneWidget);

        expect(find.text('09/12/2020'), findsOneWidget);
      },
    );

    makeDateCell('01/30/2020').test(
      'Tapping should open popup and display day of week',
      (tester) async {
        await tester.tap(find.byType(TextField));

        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        expect(find.text('Su'), findsOneWidget);
        expect(find.text('Mo'), findsOneWidget);
        expect(find.text('Tu'), findsOneWidget);
        expect(find.text('We'), findsOneWidget);
        expect(find.text('Th'), findsOneWidget);
        expect(find.text('Fr'), findsOneWidget);
        expect(find.text('Sa'), findsOneWidget);
      },
    );

    makeDateCell('01/30/2020').test(
      'Pressing up arrow and enter should select January 23',
      (tester) async {
        await tester.tap(find.byType(TextField));

        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        verify(stateManager.handleAfterSelectingRow(any, '01/23/2020'))
            .called(1);
      },
    );

    makeDateCell('01/30/2020').test(
      'Pressing left arrow and enter should select January 29',
      (tester) async {
        await tester.tap(find.byType(TextField));

        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        verify(stateManager.handleAfterSelectingRow(any, '01/29/2020'))
            .called(1);
      },
    );

    makeDateCell('01/30/2020').test(
      'Pressing right arrow and enter should select January 31',
      (tester) async {
        await tester.tap(find.byType(TextField));

        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        verify(stateManager.handleAfterSelectingRow(any, '01/31/2020'))
            .called(1);
      },
    );
  });

  group('Format yyyy-MM-dd', () {
    makeDateCell(
      String date, {
      DateTime? startDate,
    }) {
      PlutoColumn column = PlutoColumn(
        title: 'column title',
        field: 'column_field_name',
        type: PlutoColumnType.date(
          format: 'yyyy-MM-dd',
          startDate: startDate,
        ),
      );

      PlutoCell cell = PlutoCell(value: date);

      final PlutoRow row = PlutoRow(
        cells: {
          'column_field_name': cell,
        },
      );

      return PlutoWidgetTestHelper('Create DateCell', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoDateCell(
                stateManager: stateManager,
                cell: cell,
                column: column,
                row: row,
              ),
            ),
          ),
        );
      });
    }

    makeDateCell('2020-12-01').test(
      'Should display 2020-12-01',
      (tester) async {
        expect(find.text('2020-12-01'), findsOneWidget);
      },
    );

    makeDateCell(
      '2020-12-01',
      startDate: DateTime.parse('2020-12-01'),
    ).test(
      'Pressing left arrow and enter should not select a date before startDate',
      (tester) async {
        await tester.tap(find.byType(TextField));

        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);

        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        verifyNever(stateManager.handleAfterSelectingRow(
          any,
          '2020-11-30',
        ));

        expect(find.text('2020-12-01'), findsOneWidget);
      },
    );
  });
}
