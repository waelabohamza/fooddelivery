import 'package:flutter/material.dart';
import 'package:fooddelivery/home.dart';
import 'package:fooddelivery/pages/food/homefood.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';
import 'package:fooddelivery/pages/login.dart';
import 'package:fooddelivery/pages/message.dart';
import 'package:fooddelivery/pages/money/bill.dart';
import 'package:fooddelivery/pages/money/money.dart';
import 'package:fooddelivery/pages/money/sendmoneyqrcode.dart';
import 'package:fooddelivery/pages/orders/cart.dart';
import 'package:fooddelivery/pages/orders/chooseorders.dart';
import 'package:fooddelivery/pages/orders/myorders.dart';
import 'package:fooddelivery/pages/orderstaxi/myorderstaxi.dart';
import 'package:fooddelivery/pages/resetpassword/resetpassword.dart';
import 'package:fooddelivery/pages/settings.dart';
import 'package:fooddelivery/pages/taxi/hometaxi.dart';
import 'package:fooddelivery/pages/money/transfermoney.dart';
import 'package:fooddelivery/pages/restaurants/restaurant.dart';
import 'package:fooddelivery/pages/editaccount.dart';


Map<String, Widget Function(BuildContext)> routes  = 
 {
        "login": (context) => Login(),
        "itemscat": (context) => ItemsCat(),
        "homefood": (context) => HomeFood(),
        "hometaxi": (context) => HomeTaxi(),
        "home": (context) => Home(),
        "restaurant": (context) => Restaurant(),
        "cart": (context) => Cart(),
        "myorders": (context) => MyOrders(),
        "myorderstaxi": (context) => MyOrdersTaxi(),
        "editaccount": (context) => EditAccount(),
        "resetpassword": (context) => ResetPassword(),
        "chooseoreders": (context) => ChooseOrders(),
        "messages": (context) => Message(),
        "settings": (context) => Settings(),
        "money": (context) => Money(),
        "sendmoneyqrcode": (context) => SendMoneyQrCode(),
        "transfermoney": (context) => TransferMoney()    , 
        "bill" : (context) => Bill() 
      }
 ; 