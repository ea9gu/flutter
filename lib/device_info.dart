import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

Future<Map<String, String>> getDeviceInfo() async {
  Map<String, dynamic> deviceData = <String, dynamic>{};
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String device_id = '';
  String device_type = '';

  try {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      device_id = androidInfo.androidId; // 안드로이드 기기 ID
      device_type = androidInfo.model;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      device_id = iosInfo.identifierForVendor; // iOS 기기 ID
      device_type = iosInfo.model;
    }
  } on PlatformException {
    device_id = '';
    device_type = '';
  }
  return {'device_type': device_type, 'device_id': device_id};
}
