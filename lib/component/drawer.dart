import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/money/transfermoney.dart';
import 'crud.dart';
import 'package:fooddelivery/main.dart';
import 'package:carousel_slider/carousel_slider.dart';

TextStyle titledrawer = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

class MyDrawer extends StatelessWidget {
  final currentpage;
  const MyDrawer({Key key, this.currentpage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = sharedPrefs.getString("username");
    String userid = sharedPrefs.getString("id");
    String email = sharedPrefs.getString("email");
    String balance = sharedPrefs.getString("balance");
    String phone = sharedPrefs.getString("phone");
    String password = sharedPrefs.getString("password");
    String token = sharedPrefs.getString("token");

    Crud crud = new Crud();

    return Drawer(
      child: ListView(
        children: [
          SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "home" ? 4 : 0))),
            child: ListTile(
              leading: Icon(
                Icons.home_outlined,
                size: 30,
                color: Colors.grey[850],
              ),
              title: Text(
                "الصفحة الرئيسية",
                style: titledrawer,
              ),
              onTap: () {
                Navigator.of(context).pushNamed("home");
              },
            ),
          ),
             Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "home" ? 4 : 0))),
            child: ListTile(
              leading: Icon(
                Icons.shopping_basket_outlined,
                size: 30,
                color: Colors.grey[850],
              ),
              title: Text(
                "السلة",
                style: titledrawer,
              ),
              onTap: () {
                Navigator.of(context).pushNamed("cart");
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "offers" ? 4 : 0))),
            child: ListTile(
              leading: Icon(
                Icons.local_offer_outlined,
                size: 30,
                color: Colors.grey[850],
              ),
              title: Text(
                "العروض",
                style: titledrawer,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "messages" ? 4 : 0))),
            child: ListTile(
              leading: Icon(
                Icons.notifications_active_outlined,
                size: 30,
                color: Colors.grey[850],
              ),
              title: Text(
                "الاشعارات",
                style: titledrawer,
              ),
              onTap: () {
                Navigator.of(context).pushNamed("messages");
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "chooseoreders" ? 4 : 0))),
            child: ListTile(
                leading: Icon(
                  Icons.card_travel,
                  size: 30,
                  color: Colors.grey[850],
                ),
                title: Text(
                  "طلباتي السابقة",
                  style: titledrawer,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed("chooseoreders");
                }),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "transfermoney" ? 4 : 0))),
            child: ListTile(
                leading: Icon(
                  Icons.money_outlined,
                  size: 30,
                  color: Colors.grey[850],
                ),
                title: Text(
                  "تحويل الاموال",
                  style: titledrawer,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed("money");
                }),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "settings" ? 4 : 0))),
            child: ListTile(
              leading: Icon(
                Icons.settings,
                size: 30,
                color: Colors.grey[850],
              ),
              title: Text(
                "الاعدادات",
                style: titledrawer,
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("settings");
              },
            ),
          ),
          Divider(color: Colors.grey[850]),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "aboutapp" ? 4 : 0))),
            child: ListTile(
              leading: Icon(
                Icons.info_outline,
                size: 30,
                color: Colors.grey[850],
              ),
              title: Text(
                "حول التطبيق",
                style: titledrawer,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "help" ? 4 : 0))),
            child: ListTile(
              leading: Icon(
                Icons.help_outline_outlined,
                size: 30,
                color: Colors.grey[850],
              ),
              title: Text(
                "مساعدة",
                style: titledrawer,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Colors.red,
                        width: currentpage == "logout" ? 4 : 0))),
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app_outlined,
                size: 30,
                color: Colors.grey[850],
              ),
              title: Text(
                "تسجيل الخروج",
                style: titledrawer,
              ),
              onTap: () async {
                // SharedPreferences sharedPrefs = await SharedPreferences.getInstance() ;
                Map data = {"userid": userid, "usertoken": token};
                await crud.writeData("logout", data);
                sharedPrefs.clear();
                Navigator.of(context).pushReplacementNamed("login");
              },
            ),
          )
        ],
      ),
    );
  }
}
 