// ignore_for_file: prefer_is_empty, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:url_launcher/url_launcher.dart';

import 'ENV.dart';
import 'models/user.dart';

import 'routes/loginRoute.dart';
import 'routes/registerRoute.dart';

import 'routes/mainRoute.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();

  GetStorage loginData = GetStorage();
  // loginData.remove('user');
  print(loginData.read('user'));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) =>
          loginData.read('user') != null ? MainRoute() : HomeRoute(),
      // '/main': (context) => MainRoute(),
      '/login': (context) => LoginRoute(
            loginData: loginData,
          ),
      '/register': (context) => RegisterRoute()
    },
  ));
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('priananda'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 43, 43, 43),
        elevation: 0,
      ),
      body: SizedBox(
          height: screenHeight - keyboardHeight,
          child: Container(
              color: Color.fromARGB(255, 29, 29, 29),
              child: Center(
                  child: Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 40.0)),
                  Center(
                    child: Row(children: [
                      Container(
                          child: Image.asset('assets/logo/logo48.png'),
                          width: 40),
                      Text(
                        "My Tutor",
                        style: GoogleFonts.chivo(
                          textStyle: TextStyle(
                              fontSize: 38,
                              color: Color.fromARGB(255, 238, 245, 250),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ], mainAxisAlignment: MainAxisAlignment.center),
                  ),
                  Divider(
                    height: 40.0,
                  ),
                  Container(
                    child: Image.asset(
                        'assets/flat_illustration/undraw_work_time_re_hdyv.png'),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 40.0)),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 40, 15, 40),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            'Login',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 238, 245, 250),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 0, 0, 168),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        new Padding(padding: EdgeInsets.only(right: 10.0)),
                        ElevatedButton(
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 238, 245, 250),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 0, 0, 168),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )),
                  )
                ],
              )))),
    );
  }
}
