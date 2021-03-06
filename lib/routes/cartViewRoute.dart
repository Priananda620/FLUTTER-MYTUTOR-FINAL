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

import 'package:mytutor/routes/paymentRoute.dart';

import '../ENV.dart';

class CartViewRoute extends StatefulWidget {
  User userData;
  @override
  State<CartViewRoute> createState() => _CartViewRoute();

  CartViewRoute({Key? key, required this.userData}) : super(key: key);
}

class _CartViewRoute extends State<CartViewRoute> {
  List<Subject> subjectList = <Subject>[];
  int totalPayable = 0;

  @override
  void initState() {
    super.initState();
    _loadCart();
    // _loadSubject(1);
  }

  void _loadCart() {
    http.post(Uri.parse(ENV.address + "/api/cartView.php"), body: {
      "userId": widget.userData.id.toString(),
    }).then((response) {
      var subjectCartResponse = jsonDecode(response.body);

      print(response.body.toString());

      if (response.statusCode == 200 && subjectCartResponse['success']) {
        var subjectData = subjectCartResponse['data'];
        totalPayable = subjectCartResponse['total_payable'];
        print(totalPayable);

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
        print(subjectCartResponse);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildPopupDialogCheckout(context),
            );
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.payment_rounded),
        ),
        body: SizedBox(
          height: screenHeight,
          child: Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 6, 16, 31)),
              child: ListView.builder(
                  itemCount: subjectList.length != 0 ? subjectList.length : 1,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      color: Color.fromARGB(255, 42, 49, 72),
                      shadowColor: Colors.blueGrey,
                      elevation: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: subjectList.length != 0
                                ? Icon(Icons.check_circle_outline,
                                    color: Colors.cyan, size: 45)
                                : Icon(Icons.clear_rounded,
                                    color: Colors.cyan, size: 45),
                            title: Text(
                              subjectList.length != 0
                                  ? subjectList[index].name.toString()
                                  : "EMPTY",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            subtitle: Text(
                              subjectList.length != 0
                                  ? subjectList[index].description.toString()
                                  : "EMPTY",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
        ));
  }

  Widget _buildPopupDialogCheckout(BuildContext context) {
    return AlertDialog(
      title: Text("Proceed to Payment?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("You will be charged:\nTotal ( RM " +
              totalPayable.toString() +
              " )"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => PaymentRoute(
                      user: widget.userData,
                      totalpayable: totalPayable,
                    )));
            // Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Pay'),
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
