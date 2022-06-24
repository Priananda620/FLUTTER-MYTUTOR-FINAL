import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytutor/models/User.dart';
import 'package:mytutor/models/Subject.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import '../ENV.dart';

import 'package:mytutor/routes/subjectRoute.dart';
import 'package:mytutor/routes/tutorRoute.dart';

class MainRoute extends StatefulWidget {
  User userData;

  @override
  State<MainRoute> createState() => _MainRouteState();

  // MainRoute({
  //   Key? key,
  //   required this.userData,
  // }) : super(key: key);

  MainRoute({Key? key, required this.userData}) : super(key: key);
}

class _MainRouteState extends State<MainRoute> {
  // GetStorage loginData = GetStorage();

  List<Subject> subjectList = <Subject>[];
  int totalPage = 0;
  int activePage = 0;
  int totalData = 0;
  int fixedNavBarIdx = 0;
  int currentNav = 0;

  var color;

  final myProducts = List<String>.generate(1000, (i) => 'Product $i');

  // @override
  // void initState() {
  //   super.initState();
  //   _loadSubject(1);
  // }

  // void _loadSubject(int pageReq) {
  //   http.post(Uri.parse(ENV.address + "/CONTINUOUSPROJ/api/getSubjects.php"),
  //       body: {
  //         'page': pageReq.toString(),
  //       }).then((response) {
  //     var subjectResponse = jsonDecode(response.body);
  //     if (response.statusCode == 200 && subjectResponse['success']) {
  //       totalPage = subjectResponse["total_page"];
  //       activePage = subjectResponse["active_page"];
  //       totalData = subjectResponse["total_data"];

  //       var subjectData = subjectResponse['data'];
  //       if (subjectData != null) {
  //         subjectList = <Subject>[];

  //         subjectData.forEach((v) {
  //           Subject newSubject = Subject.fromJson(v);
  //           subjectList.add(newSubject);
  //           print(newSubject.name);
  //         });
  //         // print(subjectList.);
  //         setState(() {});
  //       }
  //     } else {
  //       print("NO DATA------");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget child = SubjectRoute();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    print(widget.userData.username);
    // print(ModalRoute.of(context)?.settings.name);
    if (fixedNavBarIdx == 0 && currentNav != 0) {
      // Navigator.pop(context);
      child = SubjectRoute();
      print("bbbbbbbbbb");
      currentNav = 0;
      setState(() {});
    } else if (fixedNavBarIdx == 1 && currentNav != 1) {
      // Navigator.pushNamed(context, "/tutor");
      child = TutorRoute();
      print("aaaaaaaaaaa");
      currentNav = 1;
      setState(() {});
    }
    // });

    // print(fixedNavBarIdx);

    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: fixedNavBarIdx,
            onTap: (int index) {
              setState(() {
                this.fixedNavBarIdx = index;
              });
            },
            backgroundColor: Color.fromARGB(255, 43, 43, 43),
            selectedItemColor: Color.fromARGB(255, 240, 105, 105),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.book,
                  size: 21,
                ),
                label: 'subjects',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.peopleGroup,
                  size: 21,
                ),
                label: 'tutors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions),
                label: 'subscription',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'favorites',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  size: 21,
                ),
                label: 'profile',
              ),
            ],
          ),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: const Color.fromARGB(255, 42, 49, 72)),
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: AppBar(
                  title: Text(
                    widget.userData.username.toString(),
                  ),
                  backgroundColor: const Color.fromARGB(255, 42, 49, 72),
                  centerTitle: true,
                  actions: <Widget>[
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(ENV.address +
                          "/CONTINUOUSPROJ/assets/user_images/" +
                          widget.userData.username.toString() +
                          "_" +
                          widget.userData.userImage.toString()),
                      backgroundColor: Colors.transparent,
                    )
                  ],
                ),
              )),
          body: child),
    );
  }
}
