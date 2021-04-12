import 'package:flutter/cupertino.dart';

class RefreshPartPageCat with ChangeNotifier {
  String catid   = "all" ; 
  String catname = "جميع الوجبات" ;  
  refreshcatid(val) {
    catid = val  ; 
    notifyListeners();
  }
    refreshcatname(val) {
    catname = val  ; 
    notifyListeners();
  }
}
