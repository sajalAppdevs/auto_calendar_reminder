import 'package:auto_calendar_reminder/domain/domain_export.dart';
import 'package:auto_calendar_reminder/main.dart';
import 'package:auto_calendar_reminder/presentation/data_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestUtils {
  static Future<void> pumpApp(
    WidgetTester tester, {
    required AppRepository repository,
    bool navigateToScreen2 = false,
    NavigatorObserver? observer,
  }) async {
    
    await tester.pumpWidget(
      MyApp(
        dataController: AppDataController(repository: repository),
        navigatorObserver: observer,
      ),
    );

    if (navigateToScreen2) {
      await tester.tap(find.byType(FloatingActionButton));
    }
    await tester.pumpAndSettle();
  }
}

class TestNavigatorObserver extends NavigatorObserver {
  TestNavigatorObserver({this.onPushed, this.onPopped});

  OnObservation? onPushed;
  OnObservation? onPopped;

  @override
  void didPush(Route route, Route? previousRoute) {
    if (onPushed != null) {
      onPushed!(route, previousRoute);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (onPopped != null) {
      onPopped!(route, previousRoute);
    }
  }
}

typedef OnObservation = Function(
    Route<dynamic> route, Route<dynamic>? previousRoute);
