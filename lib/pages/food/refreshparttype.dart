import 'package:flutter/cupertino.dart';

class RefreshPartPageType with ChangeNotifier {
  String typeid = "all";
  String typename = "جميع المطاعم";
  refreshtypeid(val) {
    typeid = val;
    notifyListeners();
  }

  refreshtypename(val) {
    typename = val;
    notifyListeners();
  }
}
