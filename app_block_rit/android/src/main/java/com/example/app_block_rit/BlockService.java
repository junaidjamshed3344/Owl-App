package com.example.app_block_rit;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.IBinder;


import androidx.core.app.NotificationCompat;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

public class BlockService extends Service {
    public static final String CHANNEL_ID = "ForegroundServiceChannel";
    public String topApp;

    public Date time1;
    public Date time2;
    public Date currentTime;

    public boolean checkBlockApp;

    public Intent notificationIntent;
    public PendingIntent notificationPendingIntent;



    public int onStartCommand (Intent intent, int flags, int startId) {

        createNotificationChannel();
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Block App RIT")
                .setContentText("Block App RIT is blocking the specified apps")
                .setSmallIcon(R.drawable.logo)
                .build();

        startForeground(2, notification);

        System.out.println(AllStatic.blockTimeStart+" "+AllStatic.blockTimeEnd);

        SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");

        Date date = new Date(System.currentTimeMillis());

        try {
            time1 = format.parse(AllStatic.blockTimeStart);
            time2 = format.parse(AllStatic.blockTimeEnd);
            currentTime =format.parse(format.format(date));
        } catch (ParseException e) {
            e.printStackTrace();
        }

        AllStatic.blockTimeInMillis = time2.getTime()- currentTime.getTime();
        System.out.println("Block TIME "+AllStatic.blockTimeInMillis );

        notificationIntent = new Intent(this, BlockMsg.class);
        notificationIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK );
        notificationPendingIntent = PendingIntent.getActivity(this, 3, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        AllStatic.startTimer();
        AllStatic.blockThread=true;
        blockApps(this, (ArrayList<String>) AllStatic.app_names);

        return START_NOT_STICKY;
    }


    public void blockApps(final Context context, final ArrayList<String> killingApp){
        Thread x=new Thread(new Runnable() {
            @Override
            public void run() {
                while (AllStatic.blockThread==true){
                    topApp= getForegroundApp(context);
                    Map<String,Object> map= getApp(topApp);
//                    System.out.println(map.get("system_app"));
//                    System.out.println("Ismypackage: "+topApp.equals(AllStatic.myPackageName));
                    checkBlockApp= killingApp.contains(topApp);
                    if (topApp.equals(AllStatic.myPackageName)!=true){

                        if (AllStatic.isBlack==true){
                            //if no blockApp from list will return -1
                            if (checkBlockApp!=false){
                                try {
                                    Thread.sleep(250);
                                } catch (InterruptedException e) {
                                    e.printStackTrace();
                                }
                                try {
                                    startActivity(new Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
                                    notificationPendingIntent.send();
                                } catch (PendingIntent.CanceledException e) {
                                    e.printStackTrace();
                                }
                                try {
                                    Thread.sleep(1500);
                                } catch (InterruptedException e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                        else{
                            if (checkBlockApp==false && map.get("system_app").equals(false)){
                                try {
                                    Thread.sleep(500);
                                } catch (InterruptedException e) {
                                    e.printStackTrace();
                                }
                                try {
                                    startActivity(new Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
                                    notificationPendingIntent.send();
                                } catch (PendingIntent.CanceledException e) {
                                    e.printStackTrace();
                                }
                                try {
                                    Thread.sleep(1500);
                                } catch (InterruptedException e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                    }


                }
            }
        });
        x.start();
    }

    public String getForegroundApp(Context context) {
        String currentApp = "NULL";
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            UsageStatsManager usm = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
            long time = System.currentTimeMillis();
            List<UsageStats> appList = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, time - 1000 * 1000, time);
            if (appList != null && appList.size() > 0) {
                SortedMap<Long, UsageStats> mySortedMap = new TreeMap<Long, UsageStats>();
                for (UsageStats usageStats : appList) {
                    mySortedMap.put(usageStats.getLastTimeUsed(), usageStats);
                }
                if (mySortedMap != null && !mySortedMap.isEmpty()) {
                    currentApp = mySortedMap.get(mySortedMap.lastKey()).getPackageName();
                }
            }
        } else {
            ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
            List<ActivityManager.RunningAppProcessInfo> tasks = am.getRunningAppProcesses();
            currentApp = tasks.get(0).processName;
        }
        return currentApp;
    }


    private Map<String, Object> getApp(String packageName) {
        try {
            PackageManager packageManager = AllStatic.appServiceContext.getPackageManager();
            return AllStatic.getAppData(packageManager, packageManager.getPackageInfo(packageName, 0));
        } catch (PackageManager.NameNotFoundException ignored) {
            return null;
        }
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
    public void onDestroy() {
        stopForeground(true);
        AllStatic.blockThread=false;
        AllStatic.cancelTimer();
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }
}
