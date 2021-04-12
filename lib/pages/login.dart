import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/chooseimage.dart';
import 'package:fooddelivery/component/getnotify.dart';
import 'package:fooddelivery/component/valid.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fooddelivery/component/alert.dart';


class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  File file;
  File myfile;
  String mytoken ; 

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                //  onPressed: () =>   Navigator.of(context).pop(true)  ,
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Crud crud = new Crud();

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

   

  // Start Form Controller

  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();
  GlobalKey<FormState> formstatesignin = new GlobalKey<FormState>();
  GlobalKey<FormState> formstatesignup = new GlobalKey<FormState>();

  savePref(String username, String email, String id, String balance,
      String phone, String password , String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("id", id);
    preferences.setString("username", username);
    preferences.setString("email", email);
    preferences.setString("balance", balance);
    preferences.setString("phone", phone);
    preferences.setString("password", password);
    preferences.setString("token", token);
  }

  signin() async {
   
    var formdata = formstatesignin.currentState;
    if (formdata.validate()) {
      formdata.save();
      showLoading(context);

      var data  ; 
       if ( mytoken == null ) {
          data = {"email": email.text, "password": password.text};  
       } else {
          data = {"email": email.text, "password": password.text , "token" : mytoken};
       }
       
         
      
      var responsebody = await crud.writeData("login", data);
      if (responsebody['status'] == "success") {
        savePref(
            responsebody['username'],
            responsebody['email'],
            responsebody['id'],
            responsebody['balance'],
            responsebody['phone'],
            responsebody['password'] , 
            mytoken
            )
            ;
        Navigator.of(context).pushNamed("home");
        // showdialogall(context, "s", "d") ; 
      } else {
        print("login faild");
        Navigator.of(context).pop(); 
        showdialogall(context, "خطأ", "البريد الالكتروني او كلمة المرور خاطئة");
      }
    } else {
      print("not valid");
    }
  }

  signup() async {
    if (file == null)
      return showdialogall(context, "خطأ", "يجب اضافة صورة ");
    var formdata = formstatesignup.currentState;
    if (formdata.validate()) {
      formdata.save();
      showLoading(context);
      var responsebody = await crud.addUsers(
          email.text, password.text, username.text, phone.text, file);
      if (responsebody['status'] == "success") {
        print("yes success");
        Navigator.of(context).pushNamed("login");
      } else {
        Navigator.of(context).pop() ; 
        showdialogall(
            context, "خطأ", " البريد الالكتروني او رقم الهاتف موجود سابقا ");
      }
    } else {
      print("not valid");
    }
  }

  TapGestureRecognizer _changesign;
  bool showsignin = true;

    getmytoken() async {
         mytoken =  await  getTokenDevice() ; 
    } 
  
  @override
  void initState() {
    // checkSignIn();
    _changesign = new TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showsignin = !showsignin;
          print(showsignin);
        });
      };
    getmytoken() ; 
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;

    return  Scaffold(
        body: WillPopScope(
            child: Stack(
              children: <Widget>[
                Container(height: double.infinity, width: double.infinity),
                buildPositionedtop(mdw),
                buildPositionedBottom(mdw),
                Container(
                    height: 1000,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Text(
                                    showsignin ? "تسجيل الدخول " : "انشاء حساب",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: showsignin ? 22 : 25),
                                  ))),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          buildContaineraAvatar(mdw),
                          showsignin
                              ? buildFormBoxSignIn(mdw)
                              : buildFormBoxSignUp(mdw),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Column(
                                children: <Widget>[
                                  showsignin
                                      ? InkWell(
                                          onTap: () {
                                            return Navigator.of(context)
                                                .pushNamed("resetpassword");
                                          },
                                          child: Text(
                                            "  ? هل نسيت كلمة المرور",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18),
                                          ))
                                      : SizedBox(),
                                  SizedBox(height: showsignin ? 12 : 0),
                                  showsignin
                                      ? SizedBox(height: 0)
                                      : RaisedButton(
                                          color: file == null
                                              ? Colors.red
                                              : Colors.blue,
                                          onPressed: () {
                                            return showbottommenu(context ,_chooseCamera , _chooseGallery );
                                          },
                                          child: Text(
                                            " اختيار صورة ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                  RaisedButton(
                                    color: showsignin
                                        ? Colors.blue
                                        : Colors.grey[700],
                                    elevation: 10,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 40),
                                    onPressed: showsignin ? signin : signup,
                                    // onPressed: () => Navigator.of(context).pushNamed("home"),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          showsignin
                                              ? "تسجيل الدخول"
                                              : "انشاء حساب",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(top: 4),
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Cairo'),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: showsignin
                                                      ? "في حال ليس لديك حساب يمكنك "
                                                      : "اذا كان لديك حساب يمكنك"),
                                              TextSpan(
                                                  recognizer: _changesign,
                                                  text: showsignin
                                                      ? " انشاء حساب من هنا  "
                                                      : " تسجيل الدخول من هنا  ",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ]),
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                               
                                ],
                              )),
                        ],
                      ),
                    ))
              ],
            ),
            onWillPop: _onWillPop),
      
    );
  }

  Center buildFormBoxSignIn(double mdw) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        margin: EdgeInsets.only(top: 40),
        height: 250,
        width: mdw / 1.2,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black,
              spreadRadius: .1,
              blurRadius: 1,
              offset: Offset(1, 1))
        ]),
        child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: formstatesignin,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Start Text Username
                    Text(
                      "البريد الالكتروني",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل البريد الالكتروني", false, email, "email"),
                    // End Text username
                    SizedBox(
                      height: 10,
                    ),
                    // Start Text password
                    Text("كلمة المرور",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل كلمة المرور", true, password, "password"),
                    // End Text username
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Center buildFormBoxSignUp(double mdw) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOutBack,
        margin: EdgeInsets.only(top: 20),
        height: 403,
        width: mdw / 1.2,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black,
              spreadRadius: .1,
              blurRadius: 1,
              offset: Offset(1, 1))
        ]),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
            key: formstatesignup,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Start Text Username
                    Text(
                      "اسم المستخدم",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل اسم المستخدم", false, username, "username"),
                    // End Text username
                    SizedBox(
                      height: 10,
                    ),
                    // Start Text password
                    Text("كلمة المرور",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل كلمة المرور", true, password, "password"),
                    // Start Text password CONFIRM
                    Text(" ادخل رقم الهاتف",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل رقم الهاتف هنا ", false, phone, "phone"),
                    // Start Text EMAIL
                    Text("البريد الالكتروني",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل البريد الالكتروني هنا ", false, email, "email"),

                    // End Text username
                  ],
                ),
              ),
            )),
      ),
    );
  }

  TextFormField buildTextFormFieldAll(String myhinttext, bool pass,
      TextEditingController myController, String type) {
    return TextFormField(
      controller: myController,
      obscureText: pass,
      validator: (val) {
        if (type == "email") {
          return validInput(val, 4, 40, "يكون البريد الالكتروني", "email");
        }
        if (type == "username") {
          return validInput(val, 4, 30, "يكون اسم المستخدم");
        }
        if (type == "password") {
          return validInput(val, 4, 30, "يكون كلمة المرور");
        }
        if (type == "phone") {
          return validInput(val, 4, 20, "يكون رقم الهاتف", "phone");
        }
      },
      keyboardType:type == "phone" ? TextInputType.number : TextInputType.text, 
      decoration: InputDecoration(
        
          contentPadding: EdgeInsets.all(4),
          hintText: myhinttext,
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[500], style: BorderStyle.solid, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue, style: BorderStyle.solid, width: 1))),
    );
  }

  AnimatedContainer buildContaineraAvatar(double mdw) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: showsignin ? Colors.yellow : Colors.grey[700],
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 0.1)
          ]),
      child: InkWell(
        onTap: () {
          setState(() {
            showsignin = !showsignin;
          });
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 25,
                right: 25,
                child:
                    Icon(Icons.person_outline, size: 50, color: Colors.white)),
            Positioned(
                top: 35,
                left: 60,
                child: Icon(Icons.arrow_back, size: 30, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Positioned buildPositionedtop(double mdw) {
    return Positioned(
        child: Transform.scale(
      scale: 1.3,
      child: Transform.translate(
        offset: Offset(0, -mdw / 1.7),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mdw),
                color: showsignin ? Colors.grey[800] : Colors.blue)),
      ),
    ));
  }

  Positioned buildPositionedBottom(double mdw) {
    return Positioned(
        top: 300,
        right: mdw / 1.5,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mdw),
                color: showsignin
                    ? Colors.blue[800].withOpacity(0.2)
                    : Colors.grey[800].withOpacity(0.3))));
  }

  
}
