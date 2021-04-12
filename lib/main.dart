import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fooddelivery/pages/restaurants/refreshpartcat.dart';
import 'package:fooddelivery/pages/food/refreshparttype.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
// Pages
import 'package:fooddelivery/component/addtocart.dart';
import 'package:fooddelivery/component/changelocal.dart';
import 'package:fooddelivery/home.dart';
import 'package:fooddelivery/routes.dart';
import 'package:fooddelivery/pages/login.dart';
import 'package:fooddelivery/component/applocal.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}
SharedPreferences sharedPrefs;
String userid;
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  userid = sharedPrefs.getString("id");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) {
      return AddToCart();
    }),
    ChangeNotifierProvider(create: (context) {
      return ChangeLocal();
    }) , 
      ChangeNotifierProvider(create: (context) {
      return RefreshPartPageCat();
    }) , 
      ChangeNotifierProvider(create: (context) {
      return RefreshPartPageType();
    })
  ], child: MyApp()));
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var changeLocale = Provider.of<ChangeLocal>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fooddelivery',
      theme: ThemeData(
          fontFamily: 'Cairo',
          primaryColor: Colors.brown,
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 14),
            headline6: TextStyle(fontSize: 20), // for heading in app
            headline5: TextStyle(fontSize: 20), // for title in appbar
          )),
      home: userid == null ? Login() : Home(), //
      routes: routes,
      localizationsDelegates: [
        AppLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', ''), Locale('ar', '')],
      locale: changeLocale.lang, //if want change language insiede application
      localeResolutionCallback: (currentLang, supportLang){
        if (currentLang != null) {
          for (Locale locale in supportLang) {
            if (locale.languageCode == currentLang.languageCode) {
              print(currentLang.languageCode);
              sharedPrefs.setString("lang", currentLang.languageCode);
              return currentLang;
            }
          }
        }
        return supportLang.first;
      },
    );
  }
}
