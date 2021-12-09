package com.example.app_block_rit;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

public class RewardService extends Service {
    public static final String CHANNEL_ID = "ForegroundServiceChannel";

    public RewardService() {
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public int onStartCommand (Intent intent, int flags, int startId) {
        createNotificationChannel();
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Bonus Time")
                .setContentText("Enjoy kiddo!")
                .setSmallIcon(R.drawable.logo)
                .build();

        startForeground(3, notification);

        return START_NOT_STICKY;
    }



    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    "Foreground Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onDestroy() {
        stopForeground(true);
        super.onDestroy();
    }
}
