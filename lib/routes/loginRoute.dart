// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mytutor/routes/mainRoute.dart';

import '../ENV.dart';
import '../models/user.dart';

class LoginRoute extends StatelessWidget {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  // final _formKey = GlobalKey<FormState>();

  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    // super.dispose();
  }

  // final User user;
  GetStorage loginData = GetStorage();

  LoginRoute({
    Key? key,
    required this.loginData,
  }) : super(key: key);

  // LoginRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Login to MyTutor",
        theme: ThemeData().copyWith(
            // scaffoldBackgroundColor: Colors.green,
            colorScheme: ThemeData()
                .colorScheme
                .copyWith(primary: hexToColor("#F64C72"))),
        // ignore: unnecessary_new
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: new SizedBox(
                height: (screenHeight - keyboardHeight),
                child: new Container(
                    color: Color.fromARGB(255, 43, 43, 43),
                    // ignore: avoid_unnecessary_containers
                    child: new Container(
                      child: new Center(
                          child: new SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: new Column(children: [
                                new Padding(
                                    padding: EdgeInsets.only(top: 100.0)),
                                new Text(
                                  'Log in',
                                  style: new TextStyle(
                                      color: hexToColor("#eef5fa"),
                                      fontSize: 25.0),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0)),
                                new TextFormField(
                                  controller: _loginEmailController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Email",
                                    labelStyle:
                                        TextStyle(color: hexToColor("#eef5fa")),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: hexToColor("#F64C72"),
                                    ),
                                    fillColor: hexToColor("#1d1d1d"),
                                    filled: true,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: hexToColor("#eef5fa"),
                                          width: 1.5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'input is null';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                      color: hexToColor("#eef5fa")),
                                ),

                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0)),
                                new TextFormField(
                                  controller: _loginPasswordController,
                                  obscureText: true,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Password",
                                    labelStyle:
                                        TextStyle(color: hexToColor("#eef5fa")),
                                    prefixIcon: Icon(
                                      Icons.security,
                                      color: hexToColor("#F64C72"),
                                    ),
                                    fillColor: hexToColor("#1d1d1d"),
                                    filled: true,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: hexToColor("#eef5fa"),
                                          width: 1.5),
                                    ),
                                    // enabledBorder: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(10.0),
                                    //   borderSide: BorderSide(
                                    //       color: hexToColor("#eef5fa"), width: 0),
                                    // ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'input is null';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(
                                      color: hexToColor("#eef5fa")),
                                ),

                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0)),
                                //////////
                                ////////////
                                /////////////
                                /////////////
                                ///////////////
                                //////////////////////////////
                                ////////////////////////////////////////
                                ///////////////////////////////////////////////////
                                ElevatedButton(
                                  onPressed: () async {
                                    loginAction(context);
                                  },
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 238, 245, 250),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),

                                  //style: new TextStyle(color: hexToColor("#F2A03D"), fontSize: 25.0),),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 0, 0, 168),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ]))),
                    )))));
  }

  void loginAction(context) {
    String _email = _loginEmailController.text;
    String _pass = _loginPasswordController.text;

    http.post(Uri.parse(ENV.address + "/CONTINUOUSPROJ/api/login.php"),
        body: {"email": _email, "password": _pass}).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          !data['success'] &&
          data['no_data'] != null &&
          data['no_data'] &&
          data['authenticated'] != null &&
          !data['authenticated']) {
        print("11111111111");
        Fluttertoast.showToast(
            msg: "no data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        // Navigator.of(context).pop();
      } else if (response.statusCode == 200 &&
          !data['success'] &&
          data['email_not_registered'] != null &&
          data['email_not_registered'] &&
          !data['authenticated']) {
        print("22222222222");
        Fluttertoast.showToast(
            msg: "email not registered",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else if (response.statusCode == 200 &&
          !data['success'] &&
          data['wrong_password'] != null &&
          data['wrong_password'] &&
          !data['authenticated']) {
        print("33333333333");
        Fluttertoast.showToast(
            msg: "wrong password",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else if (response.statusCode == 200 &&
          data['success'] &&
          data['authenticated']) {
        print("4444444444");
        Fluttertoast.showToast(
            msg: "success",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);

        User user = User.fromJson(data['account_data']);
        loginData.write("user", user);
        // loginData.write("username", user.username);

        print(loginData.read("user").email);

        // Navigator.pushReplacementNamed(context, '/');
        Navigator.pop(context);
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => Navigator.),
        //   (Route<dynamic> route) => false,
        // );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => MainRoute()));
      }
    });
  }
}
