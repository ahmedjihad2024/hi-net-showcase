import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'local_notification_services.dart';

// Top-level background message handler. Must be a global or static function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("💬 Background message received: ${message.data}");
  // // Initialize channels minimally in background to ensure we can display
  // await MyAwesomeNotifications.instance.initialize(isBackground: true);

  // await MyAwesomeNotifications.instance.showBasicNotification(
  //   title: message.notification?.title ?? '',
  //   body: message.notification?.body ?? '',
  //   groupKey: message.data['type'],
  //   bigPicture: message.data['image'],
  //   payload: {
  //     'remote_message': jsonEncode(message.toMap()),
  //   },
  // );
}

class FirebaseMessegingServices {
  FirebaseMessegingServices._();
  static final FirebaseMessegingServices instance =
      FirebaseMessegingServices._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FirebaseMessaging get messaging => _messaging;
  static bool _backgroundHandlerRegistered = false;
  Future<RemoteMessage?> get initialMessage => _messaging.getInitialMessage();

  Future<String?> get fcmToken async {
    String? token;
    try {
      token = await _messaging.getToken();
      print("FCM Token: $token");
    } catch (e) {
      print("Error getting FCM token: $e");
    }
    return token;
  }

  Completer<void>? _subscriptionTopicCompleter;
  Completer<void>? _unsubscriptionTopicCompleter;

  Future<void> initialize() async {
    await _messaging.setAutoInitEnabled(true);
    await requestNotificationPermission();

    await MyLocalNotifications.instance.initialize();

    // Register background handler early and only once
    if (!_backgroundHandlerRegistered) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      _backgroundHandlerRegistered = true;
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("💬 Foreground message received");
      final notification = message.notification;
      final title = notification?.title ?? '';
      final body = notification?.body ?? '';

      await MyLocalNotifications.instance.showBasicNotification(
        title: title,
        body: body,
        groupKey: message.data['type'],
        bigPicture: message.data['image'],
        payload: {'remote_message': jsonEncode(message.toMap())},
      );
    });
  }

  Future<void> requestNotificationPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  Future<void> handleInitialMessage() async {
    final _initialMessage = await this.initialMessage;
    if (_initialMessage != null) {
      handleNotificationTap(_initialMessage);
    }

    // App in background and user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationTap);
  }

  void handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification tap data: ' + message.data.toString());
    }

    // if (message.data['type'] == "Booking" &&
    //     message.data['type_id'] != null &&
    //     HomeView.homeBloc != null) {
    //   final bookingId = int.parse(message.data['type_id']);
    //   NAVIGATOR_KEY.currentState!
    //       .pushNamed(RoutesManager.bookingDetails.route, arguments: {
    //     'booking-id': bookingId,
    //     'on-review-submitted': () {
    //       HomeView.homeBloc!.add(
    //         UpdateBookingRatedEvent(
    //           bookingId: bookingId,
    //         ),
    //       );
    //     },
    //     'on-booking-cancelled': () {
    //       HomeView.homeBloc!.add(
    //         CancelBookingUpdateEvent(
    //           bookingId: bookingId,
    //         ),
    //       );
    //     },
    //   });
    // } else
    //   NAVIGATOR_KEY.currentState!.pushNamed(
    //     RoutesManager.notifications.route,
    //     arguments: {
    //       'on-review-submitted': (int bookingId) {
    //         HomeView.homeBloc!.add(
    //           UpdateBookingRatedEvent(
    //             bookingId: bookingId,
    //           ),
    //         );
    //       },
    //       'on-booking-cancelled': (int bookingId) {
    //         HomeView.homeBloc!.add(
    //           CancelBookingUpdateEvent(
    //             bookingId: bookingId,
    //           ),
    //         );
    //       },
    //     },
    //   );
  }

  Future<void> handleInitialMessageAndMessageTapped() async {
    Future.microtask(() async {
      try {
        await FirebaseMessegingServices.instance.handleInitialMessage();
        // await MyAwesomeNotifications.instance.listenToMessageTapped();
      } catch (_) {}
    });
  }

  Future<void> subscribeToTopicsOneTime({required List<String> topics}) async {
    try {
      print("🫥 Subscribing to topics...");
      await Future.wait([
        for (var topic in topics)
          FirebaseMessegingServices.instance.messaging.subscribeToTopic(topic),
      ]);
      print("🫥✅  Subscribed to topics");
    } catch (e) {
      print("🫥 Failed to subscribe to topics");
    }
  }

  Future<void> unsubscribeFromTopicsOneTime({
    required List<String> topics,
  }) async {
    try {
      print("🫥 Unsubscribing from topics...");
      await Future.wait([
        for (var topic in topics)
          FirebaseMessegingServices.instance.messaging.unsubscribeFromTopic(
            topic,
          ),
      ]);
      print("🫥✅  Unsubscribed from topics");
    } catch (e) {
      print("🫥 Failed to unsubscribe from topics");
    }
  }

  void subscribeToTopicsTryUntilSuccess({required List<String> topics}) {
    if (_subscriptionTopicCompleter != null &&
        !_subscriptionTopicCompleter!.isCompleted) {
      _subscriptionTopicCompleter!.complete();
    }
    unawaited(
      Future.doWhile(() async {
        if (_subscriptionTopicCompleter?.isCompleted ?? false) return false;

        try {
          print("🫥  Subscribing to topics...");
          await Future.wait([
            for (var topic in topics)
              FirebaseMessegingServices.instance.messaging.subscribeToTopic(
                topic,
              ),
          ]);
          print("🫥 ✅  Subscribed to topics");
          return false;
        } catch (e) {
          print("🫥 Failed to subscribe to topics");
          await Future.delayed(const Duration(seconds: 5));
          return true;
        }
      }),
    );
  }

  void unsubscribeFromTopicsTryUntilSuccess({required List<String> topics}) {
    if (_unsubscriptionTopicCompleter != null &&
        !_unsubscriptionTopicCompleter!.isCompleted) {
      _unsubscriptionTopicCompleter!.complete();
    }
    unawaited(
      Future.doWhile(() async {
        if (_unsubscriptionTopicCompleter?.isCompleted ?? false) return false;

        try {
          print("🫥 Unsubscribing from topics...");
          await Future.wait([
            for (var topic in topics)
              FirebaseMessegingServices.instance.messaging.unsubscribeFromTopic(
                topic,
              ),
          ]);
          print("🫥✅  Unsubscribed from topics");
          return false;
        } catch (e) {
          print("🫥 Failed to unsubscribe from topics");
          await Future.delayed(const Duration(seconds: 5));
          return true;
        }
      }),
    );
  }
}
