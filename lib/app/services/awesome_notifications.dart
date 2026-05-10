// // ignore_for_file: prefer_final_fields

// import 'dart:convert';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'firebase_messeging_services.dart';

// // Top-level static method for handling notification actions in background
// // This must be a global or static function for Awesome Notifications to work in background
// @pragma('vm:entry-point')
// Future<void> onAwesomeNotificationActionReceivedMethod(
//   ReceivedAction action,
// ) async {
//   debugPrint("💬 Message tapped from awesome notifications: ${action.payload}");

//   if (action.buttonKeyPressed == 'HIDE_KEY_ACTION') {
//     debugPrint("✅ Action 'Check' button pressed!");
//   }

//   final payload = action.payload ?? {};
//   if ((payload['remote_message'] ?? '').isNotEmpty) {
//     final Map<String, dynamic> remote = jsonDecode(payload['remote_message']!);
//     FirebaseMessegingServices.instance.handleNotificationTap(
//       RemoteMessage.fromMap(remote),
//     );
//   }
// }

// class MyAwesomeNotifications {
//   static final MyAwesomeNotifications _instance = MyAwesomeNotifications._();
//   static MyAwesomeNotifications get instance => _instance;
//   MyAwesomeNotifications._();

//   final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();
//   AwesomeNotifications get awesomeNotifications => _awesomeNotifications;

//   String _channelKey = 'basic_channel';
//   String get channelKey => _channelKey;

//   String? _channelName = 'Basic notifications';
//   String? get channelName => _channelName;

//   String? _channelDescription = 'Notification channel for basic notifications';
//   String? get channelDescription => _channelDescription;

//   int _notificationId = 1;
//   int get notificationId => _notificationId;

//   // Background service channel
//   String _backgroundChannelKey = 'background_channel';
//   String get backgroundChannelKey => _backgroundChannelKey;

//   bool _isInitialized = false;
//   bool get isInitialized => _isInitialized;

//   bool _isPermissionGranted = false;
//   bool get isPermissionGranted => _isPermissionGranted;

//   // Initialize notifications
//   Future<bool> initialize({
//     NotificationChannel? basicChannel,
//     bool isBackground = false,
//   }) async {
//     // Check if notifications are already initialized and permission is granted
//     if (_isInitialized) {
//       return _isInitialized;
//     }

//     // Set basic channel
//     if (basicChannel != null) {
//       if (basicChannel.channelKey == null) {
//         throw const AwesomeNotificationsException(
//           message: 'Property channelKey is required',
//         );
//       }
//       _channelName = basicChannel.channelName;
//       _channelDescription = basicChannel.channelDescription;
//       _channelKey = basicChannel.channelKey!;
//     }

//     // Initialize notifications if not initialized
//     if (!_isInitialized) {
//       _isInitialized = await _awesomeNotifications.initialize(null, [
//         basicChannel ??
//             NotificationChannel(
//               channelKey: _channelKey,
//               channelName: _channelName,
//               channelDescription: _channelDescription,
//               defaultColor: Colors.teal,
//               ledColor: Colors.white,
//               importance: NotificationImportance.High,
//               enableVibration: true,
//               onlyAlertOnce: false,
//               enableLights: true,
//               playSound: true,
//             ),
//         NotificationChannel(
//           channelKey: _backgroundChannelKey,
//           channelName: 'Background Service',
//           channelDescription: 'For background tasks',
//           defaultColor: Colors.teal,
//           ledColor: Colors.white,
//           importance: NotificationImportance.Default,
//           defaultPrivacy: NotificationPrivacy.Public,
//           enableVibration: false,
//           onlyAlertOnce: false,
//           enableLights: false,
//           playSound: false,
//         ),
//       ]);
//     }

//     // Request notification permissions after initialization
//     if (_isInitialized && !_isPermissionGranted && !isBackground) {
//       _isPermissionGranted = await requestPermissionToSendNotifications();
//     }

//     return _isInitialized;
//   }

//   // On Mesasge Tapped
//   // Listen to message tapped
//   Future<void> listenToMessageTapped() async {
//     await _awesomeNotifications.setListeners(
//       onActionReceivedMethod: onAwesomeNotificationActionReceivedMethod,
//     );
//   }

//   // Request notification permissions
//   Future<bool> requestPermissionToSendNotifications() async {
//     // // Request notification permissions
//     // return await _awesomeNotifications.requestPermissionToSendNotifications(
//     //   permissions: permissions,
//     // );
//     final status = await Permission.notification.status;

//     if (status.isGranted) {
//       return true; // Already allowed
//     }
//     if (status.isPermanentlyDenied) {
//       // User denied before - DON'T ask again
//       return false;
//     }
//     // First time - safe to request
//     final result = await Permission.notification.request();
//     return result.isGranted;
//   }

//   // Add basic channel
//   Future<void> setChannel(
//     NotificationChannel notificationChannel, {
//     bool forceUpdate = false,
//   }) async {
//     await _awesomeNotifications.setChannel(
//       notificationChannel,
//       forceUpdate: forceUpdate,
//     );
//   }

//   // Show basic notification
//   Future<bool> showBasicNotification({
//     required String title,
//     required String body,
//     String? bigPicture,
//     String? groupKey,
//     Map<String, String?>? payload,
//   }) async {
//     if (!await _awesomeNotifications.isNotificationAllowed()) return false;
//     return await _awesomeNotifications.createNotification(
//       content: NotificationContent(
//         id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//         channelKey: _channelKey,
//         title: title,
//         body: body,
//         groupKey: groupKey,
//         bigPicture: bigPicture,
//         notificationLayout: NotificationLayout.BigPicture,
//         wakeUpScreen: true,
//         payload: payload,
//       ),
//     );
//   }

//   Future<void> showNotification({
//     required NotificationContent notificationContent,
//     NotificationSchedule? schedule,
//     List<NotificationActionButton>? actionButtons,
//     Map<String, NotificationLocalization>? localizations,
//   }) async {
//     await _awesomeNotifications.createNotification(
//       content: notificationContent,
//       schedule: schedule,
//       actionButtons: actionButtons,
//       localizations: localizations,
//     );
//   }

//   // Show usage notification with progress bar
//   Future<bool> showUsageNotification({
//     required String title,
//     required String body,
//     required double? progress, // 0 to 100
//     String? channelKey,
//   }) async {
//     if (!await _awesomeNotifications.isNotificationAllowed()) return false;
//     return await _awesomeNotifications.createNotification(
//       content: NotificationContent(
//         id: 888, // Fixed ID so it updates the same notification
//         channelKey: channelKey ?? _backgroundChannelKey,
//         title: title,
//         body: body,
//         notificationLayout: NotificationLayout.ProgressBar,
//         progress: progress,
//         autoDismissible: false,
//         locked: true, // Prevents user from dismissing it easily
//         category: NotificationCategory.Progress,
//       ),
//       actionButtons: [
//         NotificationActionButton(
//           key: 'HIDE_KEY_ACTION',
//           label: 'Hide',
//           actionType: ActionType.DismissAction,
//         ),
//       ],
//     );
//   }
// }
