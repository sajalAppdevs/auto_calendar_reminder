import 'package:auto_calendar_reminder/presentation/add_option_screen.dart';
import 'package:auto_calendar_reminder/presentation/data_controllers.dart';
import 'package:auto_calendar_reminder/presentation/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'test_util.dart';

class AddOptionScreenTestCases {
  AddOptionScreenTestCases(this.repository);

  final MockAppRepository repository;


  Future<void> testDatePicker(WidgetTester tester) async {
    List<Route> navigatorEntries = [];

    TestNavigatorObserver navigatorObserver = TestNavigatorObserver()
      ..onPushed = (route, _) {
        navigatorEntries.add(route);
      };

    await TestUtils.pumpApp(
      tester,
      repository: repository,
      navigateToScreen2: true,
      observer: navigatorObserver,
    );

    await tester.tap(find.byKey(const ValueKey('dateField')));

    await tester.pumpAndSettle();

    final context = tester.state(find.byType(AddOptionScreen)).context;

    if (Theme.of(context).platform == TargetPlatform.android) {
      expect(navigatorEntries.last.runtimeType, DialogRoute<DateTime>);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      expect(navigatorEntries.last.runtimeType, CupertinoModalPopupRoute<void>);
    }
  }

  Future<void> testButtonState(WidgetTester tester) async {
    await TestUtils.pumpApp(
      tester,
      repository: repository,
      navigateToScreen2: true,
    );

    await _expectButtonDisabled(tester);

    await _setTextField(tester, 'optionNameField', 'Coffee Break');

    await _expectButtonDisabled(tester);

    await _setTextField(tester, 'descriptionField', 'Remember to take breaks');

    await _expectButtonDisabled(tester);

    await _setTextField(tester, 'iconField',
        'https://cdn-icons-png.flaticon.com/512/1792/1792931.png');

    await _expectButtonDisabled(tester);

    await _selectDateOnCalendar(tester);

    await _expectButtonEnabled(tester);
  }

  Future<void> _setTextField(
      WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(ValueKey(key)), text);
  }

  Future<void> _expectButtonDisabled(WidgetTester tester) async {
    when(() => repository.addOptions(any()))
        .thenAnswer((_) => Future.value(false));

    expect(tester.widget<AppButton>(find.byType(AppButton)).enable(), false);

    expect(
      tester
          .widget<RawMaterialButton>(find.byType(RawMaterialButton))
          .fillColor,
      Colors.grey[300],
    );

    await tester.tap(find.byType(RawMaterialButton));

    await tester.pumpAndSettle();

    verifyNever(() => repository.addOptions(any()));
  }

  Future<void> _expectButtonEnabled(WidgetTester tester) async {
    await tester.pumpAndSettle();

    expect(tester.widget<AppButton>(find.byType(AppButton)).enable(), true);

    final context = tester.state(find.byType(AddOptionScreen)).context;

    expect(
      tester
          .widget<RawMaterialButton>(find.byType(RawMaterialButton))
          .fillColor,
      Theme.of(context).primaryColor,
    );
  }

  Future<void> testScreenUIState(WidgetTester tester) async {
    await TestUtils.pumpApp(
      tester,
      repository: repository,
      navigateToScreen2: true,
    );

    _updateScreenState(tester, UIState(data: false, loading: true));

    await tester.pump();

    expect(tester.widget<AppButton>(find.byType(AppButton)).loading(), true);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

  }

  void _updateScreenState(WidgetTester tester, UIState<bool> state) {
    tester
        .state<AddOptionScreenState>(find.byType(AddOptionScreen))
        .actionsDataController
        .state = state;
  }

  Future<void> testSaveAction(WidgetTester tester) async {
    when(() => repository.addOptions(any()))
        .thenAnswer((_) => Future.value(true));

    when(() => repository.getEventOptions())
        .thenAnswer((_) => Future.value([]));

    TestNavigatorObserver navigatorObserver = TestNavigatorObserver()
      ..onPopped = (route, prevRoute) {
        if (route.runtimeType != CupertinoModalPopupRoute<void>) {
          expect(route.settings.name, AddOptionScreen.pageName);
          expect(prevRoute?.settings.name, '/');
        }
      };

    await TestUtils.pumpApp(
      tester,
      repository: repository,
      navigateToScreen2: true,
      observer: navigatorObserver,
    );

    await _setTextField(tester, 'optionNameField', 'Coffee Break');

    await _setTextField(tester, 'descriptionField', 'Remember to take breaks');

    await _setTextField(tester, 'iconField',
        'https://cdn-icons-png.flaticon.com/512/1792/1792931.png');

    await _selectDateOnCalendar(tester);

    await tester.tap(find.byType(RawMaterialButton));

    await tester.pumpAndSettle();

    verify(() => repository.addOptions(any()));
  }

  Future<void> _selectDateOnCalendar(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('dateField')));

    await tester.pumpAndSettle();

    final context = tester.state(find.byType(AddOptionScreen)).context;

    if (Theme.of(context).platform == TargetPlatform.android) {
      await tester.tap(find.text("OK"));
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      tester
          .widget<CupertinoDatePicker>(find.byType(CupertinoDatePicker))
          .onDateTimeChanged(DateTime.now());

      Navigator.of(context).pop();
    }

    await tester.pumpAndSettle();
  }
}
