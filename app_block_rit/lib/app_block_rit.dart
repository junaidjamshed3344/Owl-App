
import 'dart:async';

import 'package:flutter/services.dart';

class AppBlockRit {
  static const MethodChannel _channel = const MethodChannel('app_block_rit');

  static Future<String> startAppService(List<List<List<String>>> apps) async {
    Map<String,dynamic> args= <String,dynamic>{};
    args.putIfAbsent("apps", () => apps);
    final String msg = await _channel.invokeMethod('startAppService',args);
    return msg;
  }
  static Future<String> stopAppService() async {
    final String msg = await _channel.invokeMethod('stopAppService');
    return msg;
  }
  static Future<String> blockApps(List<String> apps) async {
    Map<String,dynamic> args= <String,dynamic>{};
    args.putIfAbsent("apps", () => apps);
    final String msg = await _channel.invokeMethod('block_app',args);
    return msg;
  }

  static Future<String> floatingWindowPermission() async {
    final String msg = await _channel.invokeMethod('floating_Window_Permission');
    return msg;
  }

  static Future<String> readAppUsagePermission() async {
    final String msg = await _channel.invokeMethod('Usage_permission');
    return msg;
  }


  static Future<String> startRewardService() async {
    final String msg = await _channel.invokeMethod('start_reward_service');
    return msg;
  }

  static Future<String> stopRewardService() async {
    final String msg = await _channel.invokeMethod('stop_reward_service');
    return msg;
  }


  static Future<String> rewardTime(String time) async {
    Map<String,dynamic> args= <String,dynamic>{};
    args.putIfAbsent("reward", () => time);
    final String msg = await _channel.invokeMethod('reward_time',args);
    return msg;
  }

  static Future<String> blockScreenDescription(String description) async {
    Map<String,dynamic> args= <String,dynamic>{};
    args.putIfAbsent("description", () => description);
    final String msg = await _channel.invokeMethod('blockScreenDescription',args);
    return msg;
  }

  static Future<String> blockScreenLabel(String label) async {
    Map<String,dynamic> args= <String,dynamic>{};
    args.putIfAbsent("label", () => label);
    final String msg = await _channel.invokeMethod('blockScreenLabel',args);
    return msg;
  }

  static Future<bool> usagePermissionStatus() async {
    final bool  status = await _channel.invokeMethod('Usage_permission_status');
    return status;
  }

  static Future<bool> floatingWindowStatus() async {
    final bool status  = await _channel.invokeMethod('floating_Window_status');
    return status;
  }

  static Future<String> setAppPackageName(String pkg) async {
    Map<String,dynamic> args= <String,dynamic>{};
    args.putIfAbsent("pkg", () => pkg);
    final String msg = await _channel.invokeMethod('setAppPackageName',args);
    return msg;
  }

  static Future<String> getRewardTime() async {
    final String msg = await _channel.invokeMethod('getRewardTime');
    return msg;
  }
}
