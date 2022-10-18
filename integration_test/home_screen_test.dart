import 'package:auto_calendar_reminder/domain/domain_export.dart';
import 'package:auto_calendar_reminder/presentation/add_option_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test/util.dart';

class HomeScreenTestCases {
  HomeScreenTestCases(this.repository);

  final MockAppRepository repository;

  Future<void> testLoadingState(WidgetTester tester) async {
    when(() => repository.getEventOptions()).thenAnswer(
      (invocation) => Future.value([])..ignore(),
    );

    await TestUtils.pumpApp(tester, repository: repository);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text("No events found"), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);
  }

  Future<void> testErrorState(WidgetTester tester) async {
    when(() => repository.getEventOptions())
        .thenThrow(Exception("An error occurred"));

    await TestUtils.pumpApp(tester, repository: repository);

    await tester.pumpAndSettle();

    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.text("An error occurred"), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text("No events found"), findsNothing);
    expect(find.byType(ListView), findsNothing);
  }

  Future<void> testEmptyState(WidgetTester tester) async {
    when(() => repository.getEventOptions())
        .thenAnswer((_) => Future.value([]));

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.text("No events found"), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);
  }

  Future<void> testDataLoadedState(WidgetTester tester) async {
    when(() => repository.getEventOptions()).thenAnswer(
      (_) => Future.value(_data),
    );

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.byType(ListView), findsOneWidget);

    for (var data in _data) {
      expect(find.byKey(Key(data.id)), findsOneWidget);
    }

    expect(find.text("No events found"), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);
  }

  Future<void> testMaterialBannerDismissedOnCancelPressed(
      WidgetTester tester) async {
    when(() => repository.getEventOptions())
        .thenThrow(Exception("An error occurred"));

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

    // await tester.pumpAndSettle();

    expect(navigatorEntries.isNotEmpty, true);
    expect(navigatorEntries, [AddOptionScreen.pageName]);
  }

  Future<void> testOnItemDraggedDelete(WidgetTester tester) async {
    when(() => repository.getEventOptions()).thenAnswer(
      (_) => Future.value(_data),
    );

    await TestUtils.pumpApp(tester, repository: repository);

    await tester.drag(find.byKey(const Key("id1")), const Offset(-700, 0));

    expect(find.byKey(const Key("id1")), findsNothing);

    expect(find.byKey(const Key("id2")), findsOneWidget);
    expect(find.byKey(const Key("id3")), findsOneWidget);
  }

  List<CalendarEventOption> get _data {
    return [
      CalendarEventOption(
          optionName: "Name1",
          optionDescription: "Description1",
          icon: "icon1",
          id: "id1",
          dateTime: "12/10/2022"),
      CalendarEventOption(
          optionName: "Name2",
          optionDescription: "Description2",
          icon: "icon2",
          id: "id2",
          dateTime: "22/12/2022"),
      CalendarEventOption(
          optionName: "Name3",
          optionDescription: "Description3",
          icon: "icon3",
          id: "id3",
          dateTime: "01/12/2022"),
    ];
  }
}
