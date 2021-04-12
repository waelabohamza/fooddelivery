import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/applocal.dart';
import 'package:fooddelivery/component/changelocal.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/drawer.dart';
import 'package:fooddelivery/component/valid.dart';
import 'package:fooddelivery/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File file;
  File myfile;

  Crud crud = new Crud();
  // var userid = sharedPrefs.getString("id") ;
  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  GlobalKey<FormState> settings = new GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0.0,
        title: Text(
          "${getLang(context, "setting")}",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.menu, size: 35, color: Colors.black),
            onPressed: () {
              scaffoldkey.currentState.openDrawer();
            }),
      ),
      drawer: MyDrawer(),
      body: WillPopScope(
          child: Container(
            child: ListView(
              children: [
                SizedBox(height: 40),
                Container(
                  color: Colors.white,
                  child: Form(
                    key: settings,
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "${getLang(context, "account_info")}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          children: [
                            ListBody(
                              children: [
                                ListTile(
                                  title: buildTextRich("اسم المستخدم :  ",
                                      "${sharedPrefs.getString("username")}"),
                                ),
                                ListTile(
                                    title: buildTextRich("كلمة المرور :  ",
                                        "${sharedPrefs.getString("password")}")),
                                ListTile(
                                  title: buildTextRich("البريد الالكتروني :  ",
                                      "${sharedPrefs.getString("email")}"),
                                ),
                              ],
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: Text("${getLang(context, "change_user_name")}",
                              style: Theme.of(context).textTheme.bodyText1),
                          children: [
                            // ListTile(title: Text("ادخل هنا اسم البريد الالكتروني الجديد"),) ,
                            ListTile(
                              title: buildTextFormUpdate(
                                  "ادخل اسم المستخدم الجديد",
                                  "settings",
                                  "username"),
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: Text("${getLang(context, "change_email")}",
                              style: Theme.of(context).textTheme.bodyText1),
                          children: [
                            // ListTile(title: Text("ادخل هنا اسم البريد الالكتروني الجديد"),) ,
                            ListTile(
                              title: buildTextFormUpdate(
                                  "ادخل اسم البريد الالكتروني الجديد",
                                  "settings",
                                  "email"),
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: Text("${getLang(context, "change_password")}",
                              style: Theme.of(context).textTheme.bodyText1),
                          children: [
                            ListTile(
                              title: buildTextFormUpdate(
                                  "ادخل كلمة المرور الجديدة",
                                  "settings",
                                  "password"),
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: Text("${getLang(context, "change_phone_no")}",
                              style: Theme.of(context).textTheme.bodyText1),
                          children: [
                            ListTile(
                              title: buildTextFormUpdate(
                                  "ادخل رقم الهاتف الجديد",
                                  "settings",
                                  "phone"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  color: Colors.white,
                  child: Consumer<ChangeLocal>(
                      builder: (context, changelocal, child) {
                    return ListTile(
                      title: Text("${getLang(context, "change_lang")}",
                          style: Theme.of(context).textTheme.bodyText1),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        var currentlang = sharedPrefs.getString("lang");
                        if (currentlang == "ar") {
                          changelocal.changeLocal(Locale("en", ""));
                        } else {
                          changelocal.changeLocal(Locale("ar", ""));
                        }
                      },
                    );
                  }),
                ),
                SizedBox(height: 40),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text("${getLang(context, "sign_out")}",
                        style: Theme.of(context).textTheme.bodyText1),
                    onTap: () async {
                      var token = sharedPrefs.getString("token");
                      var userid = sharedPrefs.getString("id");
                      Map data = {"userid": userid, "usertoken": token};
                      await crud.writeData("logout", data);
                      sharedPrefs.clear();
                    },
                    trailing: Icon(Icons.exit_to_app),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          ),
          onWillPop: () {
            Navigator.of(context).pushReplacementNamed("home");
            return null;
          }),
    );
  }

  TextFormField buildTextFormUpdate(
      String hinttext, String route, String type) {
    return TextFormField(
      controller: type == "username"
          ? username
          : type == "password"
              ? password
              : type == "email"
                  ? email
                  : type == "phone"
                      ? phone
                      : phone,
      validator: (val) {
        if (type == "username") {
          return validInput(val, 3, 30, "يكون اسم المستخدم");
        }
        if (type == "password") {
          return validInput(val, 3, 50, "تكون كلمة المرور");
        }
        if (type == "email") {
          return validInput(val, 3, 50, "يكون البريد الالكتروني", "email");
        }
        if (type == "phone") {
          return validInput(val, 3, 20, "يكون رقم الهاتف", "phone");
        }
        return null;
      },
      onFieldSubmitted: (val) {
        if (type == "username") {
          editAccountUsername();
        }
        if (type == "password") {
          editAccountPassword();
        }
        if (type == "email") {
          editAccountEmail();
        }
        if (type == "phone") {
          editAccountPhone();
        }
      },
      keyboardType: type == "phone" ? TextInputType.number : TextInputType.text,
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
          hintText: hinttext,
          filled: true,
          fillColor: Colors.grey[20],
          hintStyle: TextStyle(fontSize: 14),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.black,
            ),
            onPressed: () {
              if (type == "username") {
                editAccountUsername();
              }
              if (type == "password") {
                editAccountPassword();
              }
              if (type == "email") {
                editAccountEmail();
              }
              if (type == "phone") {
                editAccountPhone();
              }
            },
          )),
    );
  }

  RichText buildTextRich(String textone, String texttwo) {
    return RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(
          text: textone,
          style: TextStyle(color: Colors.black, fontFamily: 'Cairo')),
      TextSpan(
          text: texttwo,
          style: TextStyle(color: Colors.black, fontFamily: 'Cairo'))
    ]));
  }

  bool loading = false;

  void _chooseGallery() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.gallery);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  void _chooseCamera() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.camera);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  editAccountEmail() async {
    var formdata = settings.currentState;
    if (formdata.validate()) {
      Map data = {"userid": userid, "email": email.text};
      showLoading(context);
      var responsebody = await crud.writeData("settingsuser", data);
      if (responsebody['status'] == "success") {
        showInSnackBar("تم تغيير البريد الالكتروني بنجاح");

        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacementNamed("settings");
        });
      } else {
        Navigator.of(context).pop();
        showdialogall(context, "تنبيه", "البريد الالكتروني موجود مسبقا");
      }
    } else {}
  }

  editAccountPhone() async {
    var formdata = settings.currentState;
    if (formdata.validate()) {
      Map data = {"userid": userid, "phone": phone.text};
      showLoading(context);
      var responsebody = await crud.writeData("settingsuser", data);
      if (responsebody['status'] == "success") {
        showInSnackBar("تم تغيير رقم الهاتف بنجاح");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacementNamed("settings");
        });
      } else {
        Navigator.of(context).pop();
        showdialogall(context, "تنبيه", "رقم الهاتف موجود مسبقا");
      }
    }
  }

  editAccountUsername() async {
    var formdata = settings.currentState;
    if (formdata.validate()) {
      Map data = {"userid": userid, "username": username.text};
      print(data);
      // showLoading(context);
      var responsebody = await crud.writeData("settingsuser", data);
      if (responsebody['status'] == "success") {
        showInSnackBar("تم تغيير اسم المستخدم بنجاح");

        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacementNamed("settings");
        });
      } else {
        Navigator.of(context).pop();
        showdialogall(context, "تنبيه", "حدث خطا الرجاء المحاولة مرة اخرى");
      }
    }
  }

  editAccountPassword() async {
    var formdata = settings.currentState;
    if (formdata.validate()) {
      Map data = {"userid": userid, "password": password.text};
      showLoading(context);
      var responsebody = await crud.writeData("settingsuser", data);
      if (responsebody['status'] == "success") {
        showInSnackBar("تم تغيير كلمة المرور بنجاح");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacementNamed("settings");
        });
      } else {
        Navigator.of(context).pop();
        showdialogall(context, "تنبيه", "حدث خطا الرجاء المحاولة مرة اخرى");
      }
    }
  }

  void showInSnackBar(String value) {
    scaffoldkey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
