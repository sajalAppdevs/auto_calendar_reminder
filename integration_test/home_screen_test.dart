import 'package:auto_calendar_reminder/domain/domain_export.dart';
import 'package:auto_calendar_reminder/ext.dart';
import 'package:auto_calendar_reminder/presentation/add_option_screen.dart';
import 'package:auto_calendar_reminder/presentation/data_controllers.dart';
import 'package:auto_calendar_reminder/presentation/home_screen.dart';
import 'package:auto_calendar_reminder/presentation/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'test_util.dart';

class HomeScreenTestCases {
  HomeScreenTestCases(this.repository);

  final MockAppRepository repository;

  Future<void> testProvidersInjected(WidgetTester tester) async {
    _doWhenGetEventOptionsCalled(data: []);

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.byType(AppProvider<ActionsDataController>), findsOneWidget);
    expect(find.byType(AppProvider<AppDataController>), findsOneWidget);
    expect(find.text("Events Options"), findsOneWidget);
  }

  Future<void> testLoadingState(WidgetTester tester) async {
    _doWhenGetEventOptionsCalled(data: []);

    await TestUtils.pumpApp(tester, repository: repository);

    final dataController =
        tester.state(find.byType(HomeScreen)).context.appDataController;

    dataController.state = UIState<EventOptionList>(data: [], loading: true);

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text("No events found"), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);

    verify(() => repository.getEventOptions());
  }

  Future<void> testErrorState(WidgetTester tester) async {
    _doWhenGetEventOptionsCalled(error: true);

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.text("An error occurred"), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text("No events found"), findsNothing);
    expect(find.byType(ListView), findsNothing);

    verify(() => repository.getEventOptions());
  }

  Future<void> testEmptyState(WidgetTester tester) async {
    _doWhenGetEventOptionsCalled(data: []);

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.text("No events found"), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);

    verify(() => repository.getEventOptions());
  }

  Future<void> testDataLoadedState(WidgetTester tester) async {
    _doWhenGetEventOptionsCalled();

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.byType(ListView), findsOneWidget);

    for (var data in _data) {
      expect(find.byKey(Key(data.id)), findsOneWidget);
    }

    expect(find.text("No events found"), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);

    verify(() => repository.getEventOptions());
  }

  Future<void> testMaterialBannerDismissedOnCancelPressed(
      WidgetTester tester) async {
    _doWhenGetEventOptionsCalled(error: true);

    await TestUtils.pumpApp(tester, repository: repository);

    await tester.tap(find.byKey(const ValueKey('closeBanner')));

    await tester.pumpAndSettle();

    expect(find.byType(MaterialBanner), findsNothing);
    expect(find.text("An error occurred"), findsNothing);
  }

  Future<void> testFABPressed(WidgetTester tester) async {
    List<String> navigatorEntries = [];

    TestNavigatorObserver navigatorObserver = TestNavigatorObserver()
      ..onPushed = (route, _) {
        navigatorEntries.add(route.settings.name ?? '');
      };

    await TestUtils.pumpApp(
      tester,
      repository: repository,
      observer: navigatorObserver,
    );

    await tester.tap(find.byType(FloatingActionButton));

    await tester.pumpAndSettle();

    expect(navigatorEntries.isNotEmpty, true);
    expect(navigatorEntries, ['/', AddOptionScreen.pageName]);
  }

  Future<void> testOnItemDraggedDelete(WidgetTester tester) async {
    _doWhenGetEventOptionsCalled();

    when(() => repository.deleteOptions(any())).thenAnswer(
      (_) => Future.value(true),
    );

    await TestUtils.pumpApp(tester, repository: repository);

    await tester.drag(find.byKey(const Key("id1")), const Offset(-700, 0));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key("id2")), findsOneWidget);
    expect(find.byKey(const Key("id3")), findsOneWidget);

    expect(find.byKey(const Key("id1")), findsNothing);

    verify(() => repository.deleteOptions('id1'));
  }

  void _doWhenGetEventOptionsCalled(
      {EventOptionList? data, bool error = false}) {
    if (error) {
      when(() => repository.getEventOptions())
          .thenThrow(Exception("An error occurred"));
    } else {
      when(() => repository.getEventOptions()).thenAnswer(
        (_) => Future.value(data ?? _data),
      );
    }
  }

  List<CalendarEventOption> get _data {
    return [
      CalendarEventOption(
        optionName: "Name1",
        optionDescription: "Description1",
        icon: "https://cdn-icons-png.flaticon.com/512/1792/1792931.png",
        id: "id1",
        dateTime: "12/10/2022",
      ),
      CalendarEventOption(
        optionName: "Name2",
        optionDescription: "Description2",
        icon: "https://cdn-icons-png.flaticon.com/512/1792/1792931.png",
        id: "id2",
        dateTime: "22/12/2022",
      ),
      CalendarEventOption(
        optionName: "Name3",
        optionDescription: "Description3",
        icon: "https://cdn-icons-png.flaticon.com/512/1792/1792931.png",
        id: "id3",
        dateTime: "01/12/2022",
      ),
    ];
  }
}
