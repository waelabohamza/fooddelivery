import 'package:fooddelivery/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';

requestPermissionLocation(context) async {
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isLocationServiceEnabled) {
    showdialogall(
        context, "تنبيه", "خدمة تفعيل الموقع غير مفعلة الرجاء التفعيل");
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushNamed("home");
    });
  } else {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
    } else if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showdialogall(context, "تنبيه",
          "لا يمكن استخدام التطبيق من دون اعطاء صلاحية الوصول للموقع");
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
              await Future.delayed(Duration(seconds: 2), () {
              sharedPrefs.clear() ;
                Navigator.of(context).pushNamed("login");
              });
      }
    } else {
      permission = await Geolocator.requestPermission();
    }
  }
}
