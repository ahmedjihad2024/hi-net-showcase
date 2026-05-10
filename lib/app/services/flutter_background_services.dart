import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hi_net/app/flavor.dart';
import 'package:hi_net/app/services/live_activity_manager.dart';
import 'package:hi_net/app/services/local_notification_services.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/presentation/common/utils/fast_function.dart';
import '../../data/network/error_handler/failure.dart';
import '../../data/responses/responses.dart';
import '../../domain/usecase/get_my_orders_usecase.dart';
import '../../presentation/views/home/bloc/home_bloc.dart';
import '../../presentation/views/home/view/screens/home_view.dart';
import '../dependency_injection.dart' as inst;
import '../enums.dart';

class MyBackgroundService {
  static final MyBackgroundService _instance = MyBackgroundService._();
  static MyBackgroundService get instance => _instance;
  MyBackgroundService._();
  final lang = Platform.localeName.split("_")[0].toLowerCase();

  final service = FlutterBackgroundService();

  Future<void> initialize() async {
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: true,
        onStart: onStart,
        isForegroundMode: false,
        autoStartOnBoot: true,
        notificationChannelId: "Live Activities",
        initialNotificationTitle: "Background Service",
        initialNotificationContent: "Background Service is running",
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.dataSync],
      ),
    );
  }

  Future<bool> start() async => await service.startService();
  Future<bool> isRunning() async => await service.isRunning();
  void stop() => service.invoke("stop");
  void setAsForeground() => service.invoke("setAsForeground");
  Stream<Map<String, dynamic>?> isStopped() => service.on("isStopped");
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  LiveActivityManager liveActivityManager = LiveActivityManager();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await MyLocalNotifications.instance.initialize(isBackground: true);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
  }

  service.on("stop").listen((event) async {
    debugPrint("stop");
    await liveActivityManager.endActivity('esim-usage');
    await service.stopSelf();
  });

  final lang = Platform.localeName.split("_")[0].toLowerCase();
  // final isIos = Platform.isIOS;

  GetMyOrdersUseCase usecase = await getUsecase();

  await liveActivityManager.init(
    appGroupId:
        'group.esim_usage_live_activity', // required param but only used on iOS
    requestAndroidNotificationPermission: false,
  );

  bool isRunning = true;
  bool isAllowToFetchData = true;
  int counter = 0;
  var updatedActivityData;
  while (isRunning) {
    if (!isAllowToFetchData) {
      await liveActivityManager.createOrUpdateActivity(
        'esim-usage',
        updatedActivityData,
        removeWhenAppIsKilled: false,
        iOSEnableRemoteUpdates: true,
        staleIn: const Duration(minutes: 30),
      );
      counter++;
      if (counter == 60) {
        isAllowToFetchData = true;
        counter = 0;
      }
      await Future.delayed(Duration(seconds: 1));
      continue;
    }

    Either<Failure, MyOrdersResponse> response = await usecase.execute(
      MyOrdersParams(page: 1, limit: 1),
    );

    await response.fold(
      (failure) {
        debugPrint("failure: $failure");
      },
      (res) async {
        isAllowToFetchData = false;
        MyOrderItem? myOrderItem = res.data?.firstOrNull;

        if (myOrderItem != null && myOrderItem.esimCards.isNotEmpty && myOrderItem.status.isActive) {
          String countryName = (lang == "ar" && myOrderItem.countryNameAr.isNotEmpty
              ? myOrderItem.countryNameAr
              : myOrderItem.countryNameEn);
          String unlimited = lang == "ar" ? "غير محدود - " : "Unlimited - ";
          String dataUnitText = switch (myOrderItem.dataUnit) {
            DataUnit.MB => lang == "ar" ? "ميجابايت" : "MB",
            DataUnit.GB => lang == "ar" ? "جيجابايت" : "GB",
            DataUnit.TB => lang == "ar" ? "كيلوبايت" : "KB",
          };
          double remaining = dataAmountFormatDouble(
            myOrderItem.dataUnit,
            myOrderItem.esimCards.firstOrNull?.dataRemainingMB ?? 0,
          );
          double total = myOrderItem.dataAmount;
          double used = (total - remaining).clamp(0.0, total);
          double progress = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;

          updatedActivityData = {
            'country': countryName,
            'daysText':
                (myOrderItem.isUnlimited ? unlimited : "") +
                switch (myOrderItem.days) {
                  1 => lang == "ar" ? "يوم واحد" : "One Day",
                  2 => lang == "ar" ? "يومين" : "Two Days",
                  _ =>
                    lang == "ar"
                        ? "${myOrderItem.days} أيام"
                        : "${myOrderItem.days} Days",
                },
            'statusText': getStatusText(status: myOrderItem.status, lang: lang),
            'statusTextColor': myOrderItem.status.isReady
                ? 0xFFFFFFFF
                : myOrderItem.status.hexColor,
            'partOne': used.toStringAsFixed(1),
            'partTwo':
                '/ ${myOrderItem.isUnlimited ? "∞" : total.toStringAsFixed(1)} $dataUnitText',
            'progress': myOrderItem.isUnlimited ? 1.0 : progress,
          };
          await liveActivityManager.createOrUpdateActivity(
            'esim-usage',
            updatedActivityData,
            removeWhenAppIsKilled: false,
            iOSEnableRemoteUpdates: true,
            staleIn: const Duration(minutes: 30),
          );
        } else {
          isRunning = false;
          // await MyLocalNotifications.instance.cancelNotification(id: 888);
          // await MyLocalNotifications.instance.showBasicNotification(
          //   id: 888,
          //   title: lang == "ar" ? "تم إيقاف eSIM" : "No esim cards found",
          //   body: lang == "ar"
          //       ? "اشترِ بطاقة eSIM أولاً"
          //       : "Buy esim card first",
          // );
          // await Future.delayed(Duration(seconds: 5));
          // refresh showing notification Icon
          // service.invoke("isStopped");
          // await service.stopSelf();
        }
      },
    );
    await Future.delayed(Duration(seconds: 1));
  }
}

// Future<void> showNotification({
//   required String title,
//   required String Function(bool htmlFormat) usageText,
//   required bool isIos,
// }) async {
//   await MyLocalNotifications.instance.showAdvancedNotification(
//     id: 888,
//     title: isIos ? title : null,
//     body: isIos ? usageText(false) : null,
//     androidDetails: AndroidNotificationDetails(
//       MyLocalNotifications.instance.backgroundChannelId,
//       'Background Service',
//       ongoing: true,
//       importance: Importance.max,
//       priority: Priority.high,
//       styleInformation: isIos
//           ? null
//           : BigTextStyleInformation(
//               "<small></small>",
//               contentTitle: usageText(true),
//               htmlFormatContent: true,
//               htmlFormatContentTitle: true,
//               htmlFormatBigText: true,
//               htmlFormatSummaryText: true,
//             ),
//       actions: [
//         AndroidNotificationAction(
//           'HIDE_KEY_ACTION',
//           'Hide',
//           showsUserInterface: true,
//           cancelNotification: false,
//         ),
//       ],
//     ),
//   );
// }

Future<GetMyOrdersUseCase> getUsecase() async {
  FlavorConfig.fromFlavor(Flavor.prod);
  await inst.initAppModules();
  return inst.instance<GetMyOrdersUseCase>();
  // SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  // AppPreferences _appPreferences = AppPreferences(_sharedPreferences);
  // DioFactory _dioFactory = DioFactory(_appPreferences);
  // AppServices _appServices = AppServices(_dioFactory);
  // Repository repository = Repository(_appServices);
  // return GetMyOrdersUseCase(repository);
}

// String getNotificationUsageText({
//   required bool htmlFormat,
//   required bool isUnlimited,
//   required double usedMB,
//   required int days,
//   required double dataAmount,
//   required String country,
//   required DataUnit dataUnit,
//   required EsimStatus status,
//   required String lang,
// }) {
//   String unlimited = lang == "ar" ? "غير محدود" : "Unlimited";
//   String daysText = switch (days) {
//     1 => lang == "ar" ? "يوم واحد" : "One Day",
//     2 => lang == "ar" ? "يومين" : "Two Days",
//     _ => lang == "ar" ? "$days أيام" : "$days Days",
//   };
//   String dataUnitText = switch (dataUnit) {
//     DataUnit.MB => lang == "ar" ? "ميجابايت" : "MB",
//     DataUnit.GB => lang == "ar" ? "جيجابايت" : "GB",
//     DataUnit.TB => lang == "ar" ? "كيلوبايت" : "KB",
//   };

//   String statusText = getStatusText(status: status, lang: lang);
//   double usedDataText = dataAmountFormatDouble(dataUnit, usedMB);

//   if (htmlFormat) {
//     return '<b>$country</b><small><small>($statusText) </small><i>${isUnlimited ? "$unlimited - " : ""}$daysText</i><br><big><big>${usedDataText.toStringAsFixed(1)}</big></big>${isUnlimited ? " " : " / ${dataAmount.toStringAsFixed(1)} "}${dataUnitText}</small>';
//   }
//   return '${isUnlimited ? "$unlimited - " : ""}$daysText\n${usedDataText.toStringAsFixed(1)} ${isUnlimited ? " " : " / ${dataAmount.toStringAsFixed(1)} "}${dataUnitText}';
// }

String getStatusText({required EsimStatus status, required String lang}) {
  return switch (status) {
    EsimStatus.pending => lang == "ar" ? "قيد الانتظار" : "Pending",
    EsimStatus.ready => lang == "ar" ? "جاهز" : "Ready",
    EsimStatus.active => lang == "ar" ? "نشط" : "Active",
    EsimStatus.data_exhausted =>
      lang == "ar" ? "نفذت البيانات" : "Data Exhausted",
    EsimStatus.expired => lang == "ar" ? "منتهي" : "Expired",
    EsimStatus.cancelled => lang == "ar" ? "ملغي" : "Cancelled",
  };
}
