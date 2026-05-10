import 'package:live_activities/live_activities.dart';

class LiveActivityManager {
  static final LiveActivityManager _instance = LiveActivityManager._internal();
  factory LiveActivityManager() => _instance;
  LiveActivityManager._internal();

  final LiveActivities _liveActivities = LiveActivities();
  final Set<String> _activeActivityIds = {};

  Future<void> init({
    required String appGroupId,
    bool requestAndroidNotificationPermission = true,
  }) async {
    await _liveActivities.init(
      appGroupId: appGroupId,
      requestAndroidNotificationPermission:
          requestAndroidNotificationPermission,
    );
  }

  Future<void> createOrUpdateActivity(
    String id,
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = true,
    bool iOSEnableRemoteUpdates = true,
    Duration? staleIn,
  }) async {
    if (_activeActivityIds.contains(id)) {
      await _liveActivities.updateActivity(id, data);
    } else {
      await _liveActivities.endAllActivities();
      await _liveActivities.createActivity(
        id,
        data,
        removeWhenAppIsKilled: removeWhenAppIsKilled,
        iOSEnableRemoteUpdates: iOSEnableRemoteUpdates,
        staleIn: staleIn,
      );
      _activeActivityIds.add(id);
    }
  }

  Future<void> endActivity(String id) async {
    await _liveActivities.endActivity(id);
    _activeActivityIds.remove(id);
  }

  Future<void> endAllActivities() async {
    await _liveActivities.endAllActivities();
    _activeActivityIds.clear();
  }

  bool isActivityActive(String id) => _activeActivityIds.contains(id);
}
