import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:scanner/services/analytics/event_properties.dart';

///packageInfo
PackageInfo? packageInfo;

// ignore: avoid_classes_with_only_static_members
///
class ScanAnalytics {
  ///
  static void captureEvent(
    String event, {
    EventProperties? properties,
  }) {
    final eventProperties = (properties ?? EventProperties()).copyWith(
      appNamespace: 'app.spreadly.scanner',
      appVersion: packageInfo?.version,
      appBuild: packageInfo?.buildNumber,
      osVersion: Platform.operatingSystemVersion,
      osName: Platform.operatingSystem,
      isAuth: false,
    )
    .toJson();

    if (kDebugMode) {
      print('Posthog Event: $event - $eventProperties');
    } else {
      unawaited(
        Posthog().capture(
          eventName: event,
          properties: eventProperties,
        ),
      );
    }
  }

  ///
  static Future<bool> isFeatureEnabled(String feature) async {
    if (kDebugMode) {
      return true;
    }

    return await Posthog().isFeatureEnabled(feature) ?? false;
  }

}
