import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ENV.dart';
import '../models/user.dart';

class RegisterRoute extends StatelessWidget {
  var _image;
  final TextEditingController _emailRegisController = TextEditingController();
  final TextEditingController _usernameRegisController =
      TextEditingController();
  final TextEditingController _phoneRegisController = TextEditingController();
  final TextEditingController _addressRegisController = TextEditingController();

  final TextEditingController _passwordRegisController =
      TextEditingController();
  final TextEditingController _password2RegisController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    _emailRegisController.dispose();
    _usernameRegisController.dispose();
    _phoneRegisController.dispose();
    _addressRegisController.dispose();
    _passwordRegisController.dispose();
    _password2RegisController.dispose();
    // super.dispose();
  }

  RegisterRoute({Key? key}) : super(key: key);

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
        title: "Welcome to MyTutor",
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
                    child: new Container(
                      child: new Center(
                          child: new SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: new Column(children: [
                                new Padding(
                                    padding: EdgeInsets.only(top: 100.0)),
                                new Text(
                                  'Sign Up',
                                  style: new TextStyle(
                                      color: hexToColor("#eef5fa"),
                                      fontSize: 25.0),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0)),
                                new TextFormField(
                                  controller: _emailRegisController,
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
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                      color: hexToColor("#eef5fa")),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0)),
                                new TextFormField(
                                  controller: _usernameRegisController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Username",
                                    labelStyle:
                                        TextStyle(color: hexToColor("#eef5fa")),
                                    prefixIcon: Icon(
                                      Icons.account_box,
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
                                new TextFormField(
                                  controller: _phoneRegisController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Phone",
                                    labelStyle:
                                        TextStyle(color: hexToColor("#eef5fa")),
                                    prefixIcon: Icon(
                                      Icons.phone,
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
                                  keyboardType: TextInputType.phone,
                                  style: new TextStyle(
                                      color: hexToColor("#eef5fa")),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0)),
                                new TextFormField(
                                  controller: _addressRegisController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Address",
                                    labelStyle:
                                        TextStyle(color: hexToColor("#eef5fa")),
                                    prefixIcon: Icon(
                                      Icons.home,
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
                                  minLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  style: new TextStyle(
                                      color: hexToColor("#eef5fa")),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0)),
                                // new TextFormField(
                                //   decoration: new InputDecoration(
                                //     labelText: "Profile Picture",
                                //     labelStyle:
                                //         TextStyle(color: hexToColor("#eef5fa")),
                                //     prefixIcon: Icon(
                                //       Icons.image,
                                //       color: hexToColor("#F64C72"),
                                //     ),
                                //     fillColor: hexToColor("#1d1d1d"),
                                //     filled: true,
                                //     border: new OutlineInputBorder(
                                //       borderRadius:
                                //           new BorderRadius.circular(10.0),
                                //       borderSide: new BorderSide(),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10.0),
                                //       borderSide: BorderSide(
                                //           color: hexToColor("#eef5fa"),
                                //           width: 1.5),
                                //     ),
                                //     // enabledBorder: OutlineInputBorder(
                                //     //   borderRadius: BorderRadius.circular(10.0),
                                //     //   borderSide: BorderSide(
                                //     //       color: hexToColor("#eef5fa"), width: 0),
                                //     // ),
                                //     //fillColor: Colors.green
                                //   ),
                                //   validator: (value) {
                                //     if (value == null || value.isEmpty) {
                                //       return 'input is null';
                                //     }
                                //     return null;
                                //   },
                                //   keyboardType: TextInputType.emailAddress,
                                //   style: new TextStyle(
                                //       color: hexToColor("#eef5fa")),
                                // ),
                                ElevatedButton(
                                  onPressed: () {
                                    _getFromGallery();
                                  },
                                  child: Text(
                                    'Upload Image',
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
                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0)),
                                new TextFormField(
                                  controller: _passwordRegisController,
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
                                new TextFormField(
                                  controller: _password2RegisController,
                                  obscureText: true,
                                  decoration: new InputDecoration(
                                    labelText: "Confirm Password",
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
                                    _insertUser();
                                  },
                                  child: Text(
                                    'Sign Up',
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

  void _insertUser() {
    String _email = _emailRegisController.text;
    String _username = _usernameRegisController.text;
    String _phone = _phoneRegisController.text;
    String _address = _addressRegisController.text;
    String _pass = _passwordRegisController.text;
    String _pass2 = _password2RegisController.text;

    if (_image != null) {
      final mimeType = lookupMimeType(_image!.path);
      final bytes = File(_image!.path).readAsBytesSync();
      String base64Image =
          "data:" + mimeType! + ";base64," + base64Encode(bytes);

      // String img64 = base64Encode(bytes);
      // String base64Encoded = base64Encode(_image!.readAsBytesSync());
      // String base64Image = base64Encode(_image!.readAsBytesSync());
      print(base64Image);
      http.post(Uri.parse(ENV.address + "/CONTINUOUSPROJ/api/register.php"),
          body: {
            "email": _email,
            "username": _username,
            "phone": _phone,
            "address": _address,
            "password": _pass,
            "verify_pass": _pass2,
            "user_image64": base64Image,
          }).then((response) {
        print(response.body);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 &&
            data['success'] &&
            data['account_created'] &&
            data['account_data'] != null) {
          print("11111111111");
          Fluttertoast.showToast(
              msg: "Success Register, account_data inserted to db",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          // Navigator.of(context).pop();
        } else if (data['no_data'] && !data['success']) {
          print("222222222222");
          Fluttertoast.showToast(
              msg: "All input fields must be filled",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } else if (data['password_verify_unmatch'] && !data['success']) {
          print("333333333333");
          Fluttertoast.showToast(
              msg: "verify password must be match",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } else if (data['password_length_unmatch'] && !data['success']) {
          print("44444444444");
          Fluttertoast.showToast(
              msg: "password must be 8 chars minimum",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } else {
          print("5555555555555555");
          Fluttertoast.showToast(
              msg: "fail",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      });
    } else {
      print("222222222222");
      Fluttertoast.showToast(
          msg: "All input fields must be filled",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  _getFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }
}
