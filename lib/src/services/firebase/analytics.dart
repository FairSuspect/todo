import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static void logTodoCreated() {
    FirebaseAnalytics.instance.logEvent(name: 'todo_created');
  }

  static void logTodoDeleted() {
    FirebaseAnalytics.instance.logEvent(name: 'todo_deleted');
  }

  static void logTodoCompleted() {
    FirebaseAnalytics.instance.logEvent(name: 'todo_completed');
  }

  static void logMainScreenView() {
    FirebaseAnalytics.instance.logScreenView(screenName: 'main');
  }

  static void logCreateTodoScreenView() {
    FirebaseAnalytics.instance
        .logScreenView(screenName: 'create', screenClass: 'todo');
  }

  static void logEditTodoScreenView() {
    FirebaseAnalytics.instance
        .logScreenView(screenName: 'edit', screenClass: 'todo');
  }

  static void logScreenView(String screenName) {
    FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  }
}
