import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus/src/ui/ui.dart';

import '../../../helper/row_helper.dart';
import '../../../mock/shared_mocks.mocks.dart';

void main() {
  late MockPlutoGridStateManager stateManager;

  setUp(() {
    stateManager = MockPlutoGridStateManager();
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
    when(stateManager.isEditing).thenReturn(true);
  });

  buildWidget({
    required WidgetTester tester,
    num? cellValue = 10000,
    String? locale,
    int? decimalPoint,
  }) async {
    final PlutoColumn column = PlutoColumn(
      title: 'column',
      field: 'column',
      type: PlutoColumnType.currency(
        locale: locale,
        decimalDigits: decimalPoint,
      ),
    );

    final PlutoCell cell = PlutoCell(value: cellValue);

    final PlutoRow row = PlutoRow(
      cells: {'column': cell},
    );

    when(stateManager.currentColumn).thenReturn(column);

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: PlutoCurrencyCell(
            stateManager: stateManager,
            cell: cell,
            column: column,
            row: row,
          ),
        ),
      ),
    );
  }

  testWidgets('Should display 10000', (tester) async {
    const num cellValue = 10000;

    await buildWidget(tester: tester, cellValue: cellValue);

    expect(find.text(cellValue.toString()), findsOneWidget);
  });

  testWidgets('Should display 10000.09', (tester) async {
    const num cellValue = 10000.09;

    await buildWidget(tester: tester, cellValue: cellValue);

    expect(find.text(cellValue.toString()), findsOneWidget);
  });

  testWidgets(
    'When using comma as decimal separator in da_DK locale, should display 10000,09',
    (tester) async {
      const num cellValue = 10000.09;

      await buildWidget(tester: tester, cellValue: cellValue, locale: 'da_DK');

      expect(find.text('10000,09'), findsOneWidget);
    },
  );

  testWidgets('Should display up to 3 decimal places', (tester) async {
    const num cellValue = 10000.123;

    await buildWidget(tester: tester, cellValue: cellValue, decimalPoint: 3);

    expect(find.text(cellValue.toString()), findsOneWidget);
  });
}
