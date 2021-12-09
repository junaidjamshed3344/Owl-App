package com.example.app_block_rit;

import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.CountDownTimer;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.RequiresApi;

public class AllStatic {
    private static CountDownTimer cTimerReward;
    private static CountDownTimer cTimer;

    public static int blockTime = 0;
    public static int index=0;
    public static long blockTimeInMillis;

    public static List<List<List<String>>> profiles;
    public static List<String> app_names;
    public static List<String> startTime;
    public static List<String> endTime;

    public static String textTime;
    public static String textTimeReward;

    public static String Description;
    public static String blockScreenLabel;

    public static Boolean itsTime=false;

    public static Intent block_service_intent;
    public static Intent app_intent;
    public static Intent reward_intent;

    public static Activity activity;

    public static boolean appThread =false;
    public static boolean blockThread =true;

    public static String myPackageName;


    /////////////////////////////////////////////

    public static Map<String, UsageStats> stats;

    public static long myStartTime;
    public static long myEndTime;

    public static int startRewardMillis;
    public static int endRewardMillis;
    public static int rewardInMillis;

    public static UsageStatsManager usageStatsManager;

    public static String blockTimeStart;
    public static String blockTimeEnd;

    public static Context appServiceContext;

    public static boolean timeSlotsEnd;

    public static boolean isBlack;

    AllStatic(){
        cTimer=null;
        cTimerReward=null;
    }

    public static final int SYSTEM_APP_MASK = ApplicationInfo.FLAG_SYSTEM | ApplicationInfo.FLAG_UPDATED_SYSTEM_APP;


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public static int bonusTimeUsage(){
        int time=0;
        for(int i = 0; i< AllStatic.app_names.size(); i++){
            if (stats.get(AllStatic.app_names.get(i)) !=null){
                time+=stats.get(AllStatic.app_names.get(i)).getTotalTimeInForeground();
            }
        }
        return time;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public static int bonusTimeUsageWhite(){
        int time=0;
        List<Map<String,Object>> whiteApps= getInstalledApps(false);
        for(int i = 0; i< whiteApps.size(); i++){
            if (stats.get(whiteApps.get(i).get("package_name")) !=null){
                if (whiteApps.get(i).get("package_name").equals(AllStatic.myPackageName)!=true && app_names.contains(whiteApps.get(i).get("package_name"))!=true){
                    System.out.println(whiteApps.get(i).get("package_name"));
                    time+=stats.get(whiteApps.get(i).get("package_name")).getTotalTimeInForeground();
                }
            }
        }
        return time;
    }


    public static List<Map<String, Object>> getInstalledApps(boolean includeSystemApps) {
        PackageManager packageManager = AllStatic.appServiceContext.getPackageManager();
        List<PackageInfo> apps = packageManager.getInstalledPackages(0);
        List<Map<String, Object>> installedApps = new ArrayList<>(apps.size());

        for (PackageInfo pInfo : apps) {
            if (!includeSystemApps && isSystemApp(pInfo)) {
                continue;
            }
            Map<String, Object> map = getAppData(packageManager, pInfo);
            installedApps.add(map);
        }

        return installedApps;
    }

    public static boolean isSystemApp(PackageInfo pInfo) {
        return (pInfo.applicationInfo.flags & SYSTEM_APP_MASK) != 0;
    }

    public static Map<String, Object> getAppData(PackageManager packageManager, PackageInfo pInfo) {
        Map<String, Object> map = new HashMap<>();
        map.put("app_name", pInfo.applicationInfo.loadLabel(packageManager).toString());
        map.put("apk_file_path", pInfo.applicationInfo.sourceDir);
        map.put("package_name", pInfo.packageName);
        map.put("version_code", pInfo.versionCode);
        map.put("version_name", pInfo.versionName);
        map.put("data_dir", pInfo.applicationInfo.dataDir);
        map.put("system_app", isSystemApp(pInfo));
        map.put("install_time", pInfo.firstInstallTime);
        map.put("update_time", pInfo.lastUpdateTime);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            map.put("category", pInfo.applicationInfo.category);
        }
        return map;
    }


    public static void startRewardTimer() {
        cTimerReward = new CountDownTimer(rewardInMillis, 1000) {
            public void onTick(long millisUntilFinished) {
                long second = (millisUntilFinished / 1000) % 60;
                long minute = (millisUntilFinished / (1000 * 60)) % 60;
                long hour = (millisUntilFinished / (1000 * 60 * 60)) % 24;
                System.out.println(String.format("%02d:%02d:%02d", hour, minute, second));
            }
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            public void onFinish() {
                cancelRewardTimer();
                AllStatic.stopRewardService();
                AllStatic.startBlockService();
            }
        };
        cTimerReward.start();
    }

    static void cancelRewardTimer() {
        if(cTimerReward!=null)
            cTimerReward.cancel();
    }

    public static void startTimer() {
        cTimer = new CountDownTimer(blockTimeInMillis, 1000) {
            public void onTick(long millisUntilFinished) {
                long second = (millisUntilFinished / 1000) % 60;
                long minute = (millisUntilFinished / (1000 * 60)) % 60;
                long hour = (millisUntilFinished / (1000 * 60 * 60)) % 24;
                AllStatic.textTime = String.format("%02d:%02d:%02d", hour, minute, second);
                System.out.println(AllStatic.textTime);
            }
            public void onFinish() {
                cancelTimer();
            }
        };
        cTimer.start();
    }

    public static void cancelTimer() {
        if(cTimer!=null)
            cTimer.cancel();
    }

    public static void startBlockService(){
        AllStatic.block_service_intent = new Intent(AllStatic.appServiceContext, BlockService.class);
        AllStatic.block_service_intent.putExtra("AppName", (Serializable) AllStatic.app_names);
        AllStatic.block_service_intent.putExtra("start_time",AllStatic.blockTimeStart);
        AllStatic.block_service_intent.putExtra("end_time",AllStatic.blockTimeEnd);
        AllStatic.appServiceContext.startService(AllStatic.block_service_intent);
    }

    public static void stopBlockService(){
        if (AllStatic.block_service_intent != null) {
            AllStatic.appServiceContext.stopService(AllStatic.block_service_intent);
            AllStatic.block_service_intent = null;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public static void startRewardService(){
        AllStatic.usageStatsManager = (UsageStatsManager) AllStatic.appServiceContext.getSystemService(AllStatic.appServiceContext.USAGE_STATS_SERVICE);

        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, -1);
        AllStatic.myStartTime = System.currentTimeMillis();
        System.out.println("Start Time: "+AllStatic.myStartTime);

        AllStatic.stats = AllStatic.usageStatsManager.queryAndAggregateUsageStats(calendar.getTimeInMillis(), AllStatic.myStartTime);

        System.out.println("Length: "+ AllStatic.stats.size());
        System.out.println(AllStatic.app_names);

        if (AllStatic.isBlack==true){
            AllStatic.startRewardMillis= AllStatic.bonusTimeUsage();
        }
        else{
            AllStatic.startRewardMillis= AllStatic.bonusTimeUsageWhite();
        }

        System.out.println("totalTimeBefore: "+ AllStatic.startRewardMillis);

        AllStatic.startRewardTimer();

        AllStatic.reward_intent = new Intent(AllStatic.appServiceContext, RewardService.class);
        AllStatic.appServiceContext.startService(AllStatic.reward_intent);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public static void stopRewardService(){
        AllStatic.myEndTime = System.currentTimeMillis();
        System.out.println("End Time: "+AllStatic.myEndTime);
        AllStatic.stats = AllStatic.usageStatsManager.queryAndAggregateUsageStats(AllStatic.myStartTime, AllStatic.myEndTime);

        AllStatic.endRewardMillis= AllStatic.bonusTimeUsage();

        if (AllStatic.isBlack==true){
            AllStatic.endRewardMillis= AllStatic.bonusTimeUsage();
        }
        else{
            AllStatic.endRewardMillis= AllStatic.bonusTimeUsageWhite();
        }

        System.out.println("totalTimeAfter: "+ AllStatic.endRewardMillis);
        int millisUntilFinished = AllStatic.endRewardMillis- AllStatic.startRewardMillis;
        AllStatic.rewardInMillis=AllStatic.rewardInMillis-millisUntilFinished;
        long second = (AllStatic.rewardInMillis / 1000) % 60;
        long minute = (AllStatic.rewardInMillis / (1000 * 60)) % 60;
        long hour = (AllStatic.rewardInMillis / (1000 * 60 * 60)) % 24;
        AllStatic.textTimeReward=String.format("%02d:%02d:%02d", hour, minute, second);

        AllStatic.cancelRewardTimer();
        AllStatic.appServiceContext.stopService(AllStatic.reward_intent);
        AllStatic.reward_intent = null;
    }
}
