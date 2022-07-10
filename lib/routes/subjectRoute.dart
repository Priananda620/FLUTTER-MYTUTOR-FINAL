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
import 'dart:async';

import '../ENV.dart';

class SubjectRoute extends StatefulWidget {
  User userData;
  @override
  State<SubjectRoute> createState() => _SubjectRouteState();

  // MainRoute({
  //   Key? key,
  //   required this.loginData,
  // }) : super(key: key);

  SubjectRoute({Key? key, required this.userData}) : super(key: key);
}

class _SubjectRouteState extends State<SubjectRoute> {
  // GetStorage loginData = GetStorage();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<Subject> subjectList = <Subject>[];

  int totalPage = 0;
  int activePage = 0;
  int totalData = 0;
  int fixedNavBarIdx = 0;

  late int currSubjectPressedIdx;

  var color;

  // final myProducts = List<String>.generate(1000, (i) => 'Product $i');

  @override
  void initState() {
    super.initState();
    _loadSubject(1);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();

    super.dispose();
    // super.dispose();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void _addLoadCart(String subjectId, int indexClicked) {
    http.post(Uri.parse(ENV.address + "/api/cartProcess.php"), body: {
      "userId": widget.userData.id.toString(),
      "subjectId": subjectId,
    }).then((response) {
      var cartResponse = jsonDecode(response.body);

      print(response.body.toString());

      if (response.statusCode == 200 && cartResponse['success']) {
        print("added subject with id : " + cartResponse['subject_id']);
        Fluttertoast.showToast(
            msg: subjectList[indexClicked].name.toString() + "added to cart",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadSubject(activePage);
      } else if (response.statusCode == 200 &&
          cartResponse['cart_exist'] != null &&
          cartResponse['cart_exist']) {
        Fluttertoast.showToast(
            msg: "already in cart",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        print(cartResponse);
      }
    });
  }

  void _loadSubject(int pageReq) {
    http.post(Uri.parse(ENV.address + "/api/getSubjects.php"), body: {
      "page": pageReq.toString(),
      "searchstr": _searchController.text != ""
          ? _searchController.text.toLowerCase()
          : "",
    }).then((response) {
      // if (_searchController.text != "") {
      //   print("=--=-=-=-=-=-=-=-=--=" + _searchController.text);
      // }
      var subjectResponse = jsonDecode(response.body);

      // print(response.body.toString());

      if (response.statusCode == 200 && subjectResponse['success']) {
        totalPage = subjectResponse["total_page"];
        activePage = subjectResponse["active_page"];
        totalData = subjectResponse["total_data"];

        var subjectData = subjectResponse['data'];
        if (subjectData != null) {
          subjectList = <Subject>[];

          subjectData.forEach((v) {
            Subject newSubject = Subject.fromJson(v);
            subjectList.add(newSubject);
            // print(newSubject.toJson()['cartIsExist']);
          });
          // print(subjectList.);
          setState(() {});
        }
      } else {
        print("NO DATA------");
      }
    });
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      print(query);
      _loadSubject(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // print(fixedNavBarIdx);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              Container(
                child: Text(
                  "We Provide\nTutor Booking\nService",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                        fontSize: 38,
                        color: Color.fromARGB(255, 238, 245, 250),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                padding: const EdgeInsets.all(20),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(5, 45, 5, 0),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(15, 40, 15, 40),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Color.fromARGB(255, 43, 47, 64),
                  ),
                  child: Column(children: [
                    TextFormField(
                      onChanged: (text) {
                        _onSearchChanged(text);
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Search Subjects",
                        labelStyle: TextStyle(color: hexToColor("#eef5fa")),
                        prefixIcon: Icon(
                          Icons.search,
                          color: hexToColor("#F64C72"),
                        ),
                        fillColor: hexToColor("#1d1d1d"),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: hexToColor("#eef5fa"), width: 1.5),
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
                      style: TextStyle(color: hexToColor("#eef5fa")),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(
                              _searchController.text != ""
                                  ? "search \"" +
                                      _searchController.text.toString() +
                                      "\""
                                  : "subjects available",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),

                          Container(
                            height: 300,
                            decoration: const BoxDecoration(
                                //     border: Border(
                                //   top: BorderSide(
                                //       width: 1.0,
                                //       color: Color.fromARGB(255, 85, 96, 101)),
                                //   bottom: BorderSide(
                                //       width: 1.0,
                                //       color: Color.fromARGB(255, 71, 82, 86)),
                                // )
                                ),
                            child: ListView.builder(
                              itemCount: subjectList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      currSubjectPressedIdx = index;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(context),
                                      );
                                    },
                                    child: Container(
                                      margin: index == subjectList.length - 1
                                          ? const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0)
                                          : const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                      child: Column(
                                        children: [
                                          Container(
                                              width: 250,
                                              height: 30,
                                              child: GestureDetector(
                                                onTap: () {
                                                  currSubjectPressedIdx = index;
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        _buildPopupDialogAddToCart(
                                                            context),
                                                  );

                                                  print("Container was tapped" +
                                                      subjectList[index]
                                                          .id
                                                          .toString());
                                                },
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: FaIcon(
                                                    FontAwesomeIcons.cartPlus,
                                                    size: 25,
                                                    color: subjectList[index]
                                                                .cartIsExist
                                                                .toString() ==
                                                            "1"
                                                        ? Colors.green
                                                        : Colors.white,
                                                  ),
                                                ),
                                              )),
                                          Container(
                                              child: Image.network(
                                                ENV.address +
                                                    "/assets/courses/" +
                                                    subjectList[index]
                                                        .id
                                                        .toString() +
                                                    ".jpg",
                                                width: 120,
                                                // height: 130,
                                              ),
                                              padding: const EdgeInsets.all(7),
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 10),
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 233, 233, 233),
                                                  // borderRadius: BorderRadius.only(
                                                  //   topRight: Radius.circular(100),
                                                  //   topLeft: Radius.circular(100),
                                                  //   bottomLeft:
                                                  //       Radius.circular(100),
                                                  //   bottomRight:
                                                  //       Radius.circular(100),
                                                  // ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          50, 46, 46, 46),
                                                      spreadRadius: 4,
                                                      blurRadius: 20,
                                                    ),
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          20, 40, 40, 40),
                                                      spreadRadius: -4,
                                                      blurRadius: 10,
                                                    )
                                                  ])),
                                          const Spacer(),
                                          Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    // alignment: Alignment.centerLeft,
                                                    // width: 100,
                                                    margin: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 12),
                                                    child: Text(
                                                      subjectList[index]
                                                          .name
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Container(
                                                    // alignment: Alignment.centerLeft,

                                                    child: Row(children: [
                                                      Container(
                                                        color: Color.fromARGB(
                                                            255, 64, 64, 64),
                                                        padding:
                                                            EdgeInsets.all(7),
                                                        child: Text(
                                                          "RM" +
                                                              subjectList[index]
                                                                  .price
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            10, 0, 0, 0),
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 5, 10, 5),
                                                        child: Text(
                                                          subjectList[index]
                                                                  .sessionsNumber
                                                                  .toString() +
                                                              " sessions",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromARGB(
                                                              167,
                                                              13,
                                                              255,
                                                              186),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color
                                                                  .fromARGB(
                                                                      50,
                                                                      46,
                                                                      46,
                                                                      46),
                                                              spreadRadius: 4,
                                                              blurRadius: 20,
                                                            ),
                                                            BoxShadow(
                                                              color: Color
                                                                  .fromARGB(
                                                                      20,
                                                                      40,
                                                                      40,
                                                                      40),
                                                              spreadRadius: -4,
                                                              blurRadius: 10,
                                                            )
                                                          ],
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromARGB(
                                                                      195,
                                                                      142,
                                                                      218,
                                                                      143),
                                                              width: 2),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            10, 0, 0, 0),
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 5, 10, 5),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .white),
                                                            children: [
                                                              TextSpan(
                                                                text: subjectList[
                                                                        index]
                                                                    .rating
                                                                    .toString(),
                                                              ),
                                                              const TextSpan(
                                                                text: " ",
                                                              ),
                                                              const WidgetSpan(
                                                                child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .star,
                                                                  size: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromARGB(
                                                              167, 255, 65, 13),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color
                                                                  .fromARGB(
                                                                      77,
                                                                      57,
                                                                      29,
                                                                      4),
                                                              spreadRadius: 4,
                                                              blurRadius: 20,
                                                            ),
                                                            BoxShadow(
                                                              color: Color
                                                                  .fromARGB(115,
                                                                      62, 6, 6),
                                                              spreadRadius: -4,
                                                              blurRadius: 10,
                                                            )
                                                          ],
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromARGB(
                                                                      199,
                                                                      239,
                                                                      72,
                                                                      0),
                                                              width: 2),
                                                        ),
                                                      )
                                                    ]),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 20, 15, 20),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color.fromARGB(255, 79, 45, 230),
                                              Color.fromARGB(255, 0, 24, 204),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  107, 6, 58, 189),
                                              spreadRadius: 4,
                                              blurRadius: 20,
                                            ),
                                          ]),
                                    ));
                              },
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          ),
                          SizedBox(
                            height: 50.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: totalPage,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if ((activePage - 1) == index) {
                                  color = Colors.red;
                                } else {
                                  color = Colors.black;
                                }
                                return Container(
                                  color: (activePage - 1) == index
                                      ? Color.fromARGB(255, 35, 35, 35)
                                      : Color.fromARGB(255, 108, 108, 108),
                                  width: 40,
                                  child: TextButton(
                                      onPressed: () =>
                                          {_loadSubject(index + 1)},
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(color: color),
                                      )),
                                );
                              },
                            ),
                          ),

                          ////////////////////////////////////////////////////////////////////
                        ])),
                  ])),
              Container(
                  // color: const Color.fromARGB(255, 43, 47, 64),
                  padding: EdgeInsets.all(20),
                  width: screenWidth,
                  height: 200,
                  // color: Color.fromARGB(255, 9, 44, 84),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "UI made fully by priananda azhar, fonts from GoogleFonts, icons from Font Awesome.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ))),
                        Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                "Follow me on :",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              // color: Colors.amber,
                              child: Row(children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Colors.deepOrange,
                                  ),
                                  child: IconButton(
                                    // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    icon: const FaIcon(
                                        FontAwesomeIcons.instagram),
                                    color: Colors.white,
                                    onPressed: () async {
                                      const url =
                                          'https://instagram.com/azhar620';
                                      // ignore: deprecated_member_use
                                      if (await canLaunch(url)) {
                                        // ignore: deprecated_member_use
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Color.fromARGB(255, 51, 111, 181),
                                  ),
                                  child: IconButton(
                                    // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    icon: FaIcon(FontAwesomeIcons.github),
                                    color: Colors.white,
                                    onPressed: () async {
                                      const url =
                                          'https://github.com/Priananda620';
                                      // ignore: deprecated_member_use
                                      if (await canLaunch(url)) {
                                        // ignore: deprecated_member_use
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                  ),
                                ),
                              ]),
                            )
                          ],
                        )),
                      ])
                  // margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  // child: ,
                  )
            ]),
            color: const Color.fromARGB(255, 32, 33, 44),
          ),
          // color: Colors.red.withOpacity(0.6),
          // height: screenHeight,
          // width: screenWidth,
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: Text(subjectList[currSubjectPressedIdx].name.toString()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(subjectList[currSubjectPressedIdx].description.toString()),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildPopupDialogAddToCart(BuildContext context) {
    return AlertDialog(
      title: Text("Add To Cart"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Add \"" +
              subjectList[currSubjectPressedIdx].name.toString() +
              "\" To Cart?"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _addLoadCart(subjectList[currSubjectPressedIdx].id.toString(),
                currSubjectPressedIdx);
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Add To Cart'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
