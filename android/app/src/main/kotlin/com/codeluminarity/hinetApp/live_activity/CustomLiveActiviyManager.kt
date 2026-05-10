package com.codeluminarity.hinetApp.live_activity

import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.widget.RemoteViews
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.Rect
import android.graphics.RectF
import android.media.session.MediaSession
import androidx.annotation.RequiresApi
import com.codeluminarity.hinetApp.MainActivity
import com.codeluminarity.hinetApp.R
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.net.HttpURLConnection
import java.net.URL
import com.example.live_activities.LiveActivityManager
import androidx.core.graphics.scale
import androidx.core.graphics.createBitmap

class CustomLiveActivityManager(context: Context) :
    LiveActivityManager(context) {
    private val context: Context = context.applicationContext
    private val pendingIntent = PendingIntent.getActivity(
        context, 200, Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        }, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    private val remoteViews = RemoteViews(
        context.packageName, R.layout.live_activity
    )

    private val remoteViewsSmall = RemoteViews(
        context.packageName, R.layout.live_activity_small
    )

    // This function is not necessary
    // This function will load an image from a URL and resize it to 64dp
    suspend fun loadImageBitmap(imageUrl: String?): Bitmap? {
        // Convert 64dp to pixels based on device density
        val dp = context.resources.displayMetrics.density.toInt()

        return withContext(Dispatchers.IO) {
            if (imageUrl.isNullOrEmpty()) return@withContext null
            try {
                val url = URL(imageUrl)
                val connection = url.openConnection() as HttpURLConnection
                connection.doInput = true
                connection.connectTimeout = 3000
                connection.readTimeout = 3000
                connection.connect()
                connection.inputStream.use { inputStream ->
                    // Decode the bitmap from the input stream and resize it
                    val originalBitmap = BitmapFactory.decodeStream(inputStream)
                    originalBitmap?.let {
                        val targetSize = 64 * dp
                        val aspectRatio =
                            it.width.toFloat() / it.height.toFloat()
                        val (targetWidth, targetHeight) = if (aspectRatio > 1) {
                            targetSize to (targetSize / aspectRatio).toInt()
                        } else {
                            (targetSize * aspectRatio).toInt() to targetSize
                        }
                        it.scale(targetWidth, targetHeight)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }
    }

    private fun getRoundedCornerBitmap(bitmap: Bitmap, pixels: Int): Bitmap {
        // First, crop to a square from the center
        val size = if (bitmap.width > bitmap.height) bitmap.height else bitmap.width
        val left = (bitmap.width - size) / 2
        val top = (bitmap.height - size) / 2
        val squareBitmap = Bitmap.createBitmap(bitmap, left, top, size, size)

        val output = createBitmap(size, size)
        val canvas = Canvas(output)
        val paint = Paint()
        val rect = Rect(0, 0, size, size)
        val rectF = RectF(rect)
        val roundPx = pixels.toFloat()
        
        paint.isAntiAlias = true
        canvas.drawColor(0, PorterDuff.Mode.CLEAR)
        paint.color = -0x1000000 // Black (opaque)
        canvas.drawRoundRect(rectF, roundPx, roundPx, paint)
        
        paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_IN)
        canvas.drawBitmap(squareBitmap, rect, rect, paint)
        
        return output
    }

    private fun getRoundedCornerBitmapWithBorder(bitmap: Bitmap, pixels: Int, borderWidth: Int, borderColor: Int): Bitmap {
        val size = if (bitmap.width > bitmap.height) bitmap.height else bitmap.width
        val left = (bitmap.width - size) / 2
        val top = (bitmap.height - size) / 2
        val squareBitmap = Bitmap.createBitmap(bitmap, left, top, size, size)

        val output = createBitmap(size, size)
        val canvas = Canvas(output)
        
        val paint = Paint()
        val rect = Rect(0, 0, size, size)
        val rectF = RectF(rect)
        val roundPx = pixels.toFloat()

        // 1. Draw rounded rectangle as mask
        paint.isAntiAlias = true
        canvas.drawARGB(0, 0, 0, 0)
        paint.color = -0x1000000
        canvas.drawRoundRect(rectF, roundPx, roundPx, paint)

        // 2. Draw bitmap into mask
        paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_IN)
        canvas.drawBitmap(squareBitmap, rect, rect, paint)

        // 3. Draw border
        paint.xfermode = null
        paint.style = Paint.Style.STROKE
        paint.color = borderColor
        paint.strokeWidth = borderWidth.toFloat()
        canvas.drawRoundRect(rectF, roundPx, roundPx, paint)

        return output
    }

    private fun createRoundedColorBitmap(color: Int, width: Int, height: Int, radiusPx: Int): Bitmap {
        val output = createBitmap(width, height)
        val canvas = Canvas(output)
        val paint = Paint().apply {
            this.color = color
            this.isAntiAlias = true
        }
        val rectF = RectF(0f, 0f, width.toFloat(), height.toFloat())
        canvas.drawRoundRect(rectF, radiusPx.toFloat(), radiusPx.toFloat(), paint)
        return output
    }

    // This function will update the RemoteViews with the data
    private suspend fun updateRemoteViews(
        countryName: String,
        daysText: String,
        statusText: String,
        // statusBgColor: Int,
        statusTextColor: Int,
        partOne: String,
        partTwo: String,
        // flagUrl: String?,
    ) {
        val dp = context.resources.displayMetrics.density

        remoteViews.setTextViewText(R.id.country_name, countryName)
        remoteViews.setTextViewText(R.id.days_text, daysText)
        remoteViews.setTextViewText(R.id.used_data, partOne)
        remoteViews.setTextViewText(R.id.total_data, partTwo)

        remoteViewsSmall.setTextViewText(R.id.country_name, countryName)
        remoteViewsSmall.setTextViewText(R.id.used_data, partOne)
        remoteViewsSmall.setTextViewText(R.id.total_data, partTwo)

        // Load and process app icon for status_icon
        try {
            val appIcon = BitmapFactory.decodeResource(context.resources, R.mipmap.ic_launcher)
            if (appIcon != null) {
                // Scale to 24dp for consistency
                val iconSize = (24 * dp).toInt()
                val scaledIcon = appIcon.scale(iconSize, iconSize)
                
                // Add rounded corners (rounded rectangle) and no border
                val roundedIcon = getRoundedCornerBitmap(
                    scaledIcon, 
                    (4 * dp).toInt() // small radius for rounded rectangle
                )
                
                remoteViews.setImageViewBitmap(R.id.status_icon, roundedIcon)
                remoteViewsSmall.setImageViewBitmap(R.id.status_icon, roundedIcon)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    // This function will be called by the plugin to build the notification
    // [notification] is the Notification.Builder instance used by the plugin
    // [event] is the event type ("create" or "update")
    // [data] is the data passed to the plugin
    override suspend fun buildNotification(
        notification: Notification.Builder,
        event: String,
        data: Map<String, Any>
    ): Notification {
        val country = (data["country"] as? String) ?: "eSIM"
        val daysText = (data["daysText"] as? String) ?: ""
        val statusText = (data["statusText"] as? String) ?: "Active"
        
        // Extract colors, assuming they come as Long/Int from Flutter (0xAARRGGBB)
        // val statusBgColor = (data["statusBgColor"] as? Number)?.toInt() ?: 0xFF4CAF50.toInt()
        val statusTextColor = (data["statusTextColor"] as? Number)?.toInt() ?: 0xFFFFFFFF.toInt()
        
        val partOne = (data["partOne"] as? String) ?: "0.0"
        val partTwo = (data["partTwo"] as? String) ?: "/ 0.0 GB"
        
        // val flagUrl = data["flagUrl"] as? String

       updateRemoteViews(
           country,
           daysText,
           statusText,
          //  statusBgColor,
           statusTextColor,
           partOne,
           partTwo,
          //  flagUrl
       )

//        val mediaSession = MediaSession(context, "player")
//        val style = Notification.MediaStyle()
//            .setMediaSession(mediaSession.sessionToken)


        return notification
            .setSmallIcon(R.drawable.ic_notification_icon)
            .setOngoing(false)
            .setContentIntent(pendingIntent)
            .setShowWhen(false)
            .setCustomContentView(remoteViewsSmall)
//           .setStyle(style)
            // .setStyle(Notification.DecoratedCustomViewStyle())
            .setCustomBigContentView(remoteViews) // Expanded view
            .setPriority(Notification.PRIORITY_HIGH)
            .setCategory(Notification.CATEGORY_EVENT)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .build()
    }
}