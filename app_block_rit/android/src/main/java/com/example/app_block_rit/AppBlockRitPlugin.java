package com.example.app_block_rit;

import android.app.AppOpsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

public class AppBlockRitPlugin implements FlutterPlugin, MethodCallHandler, PluginRegistry.RequestPermissionsResultListener,  ActivityAware {
  private MethodChannel channel;
  private Context context=null;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "app_block_rit");
    channel.setMethodCallHandler(this);
    setContext(flutterPluginBinding.getApplicationContext());
  }

  public void setContext(Context context) {
    this.context = context;
  }


  @RequiresApi(api = Build.VERSION_CODES.M)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    if (call.method.equals("startAppService")) {
      AllStatic.profiles = call.argument("apps");

      Calendar rightNow = Calendar.getInstance();
      System.out.println(AllStatic.profiles);
      System.out.println(rightNow);
      System.out.println(AllStatic.appThread );
      AllStatic.appThread =true;
      System.out.println(AllStatic.appThread );
      AllStatic.startTime=null;
      AllStatic.endTime=null;
      System.out.println( AllStatic.profiles.size());
      for(int i = 0; i < AllStatic.profiles.size(); i++){
        if (AllStatic.profiles.get(i).get(0).indexOf(Integer.toString(rightNow.get(Calendar.DAY_OF_WEEK)))!=-1){
          System.out.println("Profile "+i);
          AllStatic.startTime= AllStatic.profiles.get(i).get(1);
          AllStatic.endTime= AllStatic.profiles.get(i).get(2);
          AllStatic.app_names= AllStatic.profiles.get(i).get(3);
          if (AllStatic.profiles.get(i).get(4).get(0).equals("true")){
            AllStatic.isBlack=true;
          }
          else{
            AllStatic.isBlack=false;
          }
          System.out.println(AllStatic.app_names);
          System.out.println(AllStatic.startTime);
          System.out.println(AllStatic.endTime);
          System.out.println(AllStatic.isBlack);
          break;
        }
      }


      System.out.println(AllStatic.startTime);
      System.out.println(AllStatic.endTime);

      AllStatic.app_intent=new Intent(AllStatic.activity,AppService.class);
      AllStatic.activity.startService(AllStatic.app_intent);
      result.success("App Service Started");
    }

    else if (call.method.equals("stopAppService")){
      AllStatic.activity.stopService(AllStatic.app_intent);
      result.success("App Service Ended");
    }

    else if (call.method.equals("Usage_permission")){
      AllStatic.activity.startActivity(new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS));
      result.success("Usage_permission");
    }

    else if (call.method.equals("Usage_permission_status")){
      result.success(isUsagePermission(this.context));
    }

    else if (call.method.equals("floating_Window_Permission")){
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        AllStatic.activity.startActivity(new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION));
        result.success("floating_Window_permission");
      }
      else{
        result.success("SDK version smaller than Pie");
      }
    }

    else if (call.method.equals("floating_Window_status")){
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        result.success(isSystemAlertPermission(this.context));
      }
      else{
        result.success(true);
      }
    }

    else if (call.method.equals("reward_time")){
      AllStatic.textTimeReward = call.argument("reward");
      SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");

      try {
        AllStatic.rewardInMillis=(int) (simpleDateFormat.parse(AllStatic.textTimeReward).getTime() - simpleDateFormat.parse("00:00:00").getTime());
      } catch (ParseException e) {
        e.printStackTrace();
      }

      result.success("Set reward time!");
    }

    else if (call.method.equals("start_reward_service")){
      if (AllStatic.app_names != null && AllStatic.blockTimeStart != null && AllStatic.blockTimeEnd != null && AllStatic.reward_intent == null && AllStatic.itsTime==true) {
        AllStatic.stopBlockService();
        AllStatic.startRewardService();
        result.success("Reward Service Started!");
      } else {
        result.success("Reward Service not Started!");
      }
    }

    else if (call.method.equals("stop_reward_service")){
      if (AllStatic.reward_intent != null) {
        AllStatic.stopRewardService();
        AllStatic.startBlockService();
        result.success("Stopped Reward Service");
      } else {
        result.success("Unable to Stop Reward Service");
      }
    }

    else if (call.method.equals("blockScreenDescription")){
      String description= call.argument("description");
      if (description != null) {
        AllStatic.Description=description;
        result.success("Description set");
      } else {
        result.success("Description not set");
      }
    }

    else if (call.method.equals("blockScreenLabel")){
      String label= call.argument("label");
      if (label != null) {
        AllStatic.blockScreenLabel=label;
        result.success("label set");
      } else {
        result.success("label not set");
      }
    }

    else if (call.method.equals("getRewardTime")){
      if (AllStatic.rewardInMillis>=0 && AllStatic.textTimeReward!=null){
        result.success(AllStatic.textTimeReward);
      }else{
        result.success("null");
      }
    }
    else if (call.method.equals("setAppPackageName")){
      String pkg= call.argument("pkg");
      if (pkg!=null){
        AllStatic.myPackageName=pkg;
      }
    }

    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    AllStatic.activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    AllStatic.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    AllStatic.activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    AllStatic.activity = null;
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    return false;
  }

//  @RequiresApi(api = Build.VERSION_CODES.M)
//  public boolean usagePermission(){
////    try {
////      PackageManager packageManager = AllStatic.activity.getApplicationContext().getPackageManager();
////      ApplicationInfo applicationInfo = packageManager.getApplicationInfo(AllStatic.activity.getApplicationContext().getPackageName(), 0);
////      AppOpsManager appOpsManager = (AppOpsManager) AllStatic.activity.getApplicationContext().getSystemService(Context.APP_OPS_SERVICE);
////      int mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, applicationInfo.uid, applicationInfo.packageName);
////      return (mode == AppOpsManager.MODE_ALLOWED);
////
////    } catch (PackageManager.NameNotFoundException e) {
////      return false;
////    }
//    if(!Settings.canDrawOverlays(AllStatic.activity.getApplicationContext())){
//      // ask for setting
//      Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + AllStatic.activity.getApplicationContext().getPackageName()));
//      AllStatic.activity.startActivityForResult(intent, 123);
//    }
//  }

  Boolean isUsagePermission(Context context) {
    try {
      PackageManager packageManager = context.getPackageManager();
      ApplicationInfo applicationInfo = packageManager.getApplicationInfo(context.getPackageName(), 0);
      AppOpsManager appOpsManager = (AppOpsManager) context.getApplicationContext().getSystemService(Context.APP_OPS_SERVICE);
      int mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, applicationInfo.uid, applicationInfo.packageName);
      return (mode == AppOpsManager.MODE_ALLOWED);
    } catch (PackageManager.NameNotFoundException e) {
      return false;
    }
  }

  Boolean isSystemAlertPermission(Context context) {
    try {
      PackageManager packageManager = context.getPackageManager();
      ApplicationInfo applicationInfo = packageManager.getApplicationInfo(context.getPackageName(), 0);
      AppOpsManager appOpsManager = (AppOpsManager) context.getApplicationContext().getSystemService(Context.APP_OPS_SERVICE);
      int mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_SYSTEM_ALERT_WINDOW, applicationInfo.uid, applicationInfo.packageName);
      return (mode == AppOpsManager.MODE_ALLOWED);
    } catch (PackageManager.NameNotFoundException e) {
      return false;
    }
  }

}
