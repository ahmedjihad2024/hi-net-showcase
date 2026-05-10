package com.codeluminarity.hinetApp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import androidx.appcompat.app.AppCompatDelegate
import com.codeluminarity.hinetApp.live_activity.CustomLiveActivityManager
import com.example.live_activities.LiveActivityManagerHolder

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        LiveActivityManagerHolder.instance = CustomLiveActivityManager(this)
    }
}

