import 'package:flutter/material.dart';

import 'app.dart';
import 'core/push/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Boot Firebase + register background message handler before the
  // first frame, so a cold-start-via-push launch doesn't race the
  // message listeners. No-op on Flutter Web; no-op on subsequent
  // hot reloads.
  //
  // This does NOT request notification permission — that happens
  // post-login via `window.evair.registerForPush()`.
  await PushNotificationService.instance.initialize();

  runApp(const EvairSimApp());
}
