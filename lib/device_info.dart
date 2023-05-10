import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.androidId; // 안드로이드 기기 ID
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    return iosInfo.identifierForVendor; // iOS 기기 ID
  }
  return null;
}
