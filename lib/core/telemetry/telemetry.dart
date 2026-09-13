import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Centralizes optional Firebase telemetry so feature code remains platform-safe.
abstract final class Telemetry {
  static bool get _firebaseAvailable => Firebase.apps.isNotEmpty;

  static bool get _crashlyticsSupported {
    if (kIsWeb) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,
      _ => false,
    };
  }

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (!_firebaseAvailable) return;
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (_) {
      // Telemetry must never interrupt the user flow.
    }
  }

  static Future<void> recordError(
    Object error,
    StackTrace stack, {
    required String reason,
  }) async {
    if (!_firebaseAvailable || !_crashlyticsSupported) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        fatal: false,
      );
    } catch (_) {
      // Crash reporting must never mask the original failure.
    }
  }
}
