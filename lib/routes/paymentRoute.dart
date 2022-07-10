import 'dart:async';

import 'package:flutter/material.dart';
import '../ENV.dart';
import '../models/subject.dart';
import 'package:mytutor/models/User.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentRoute extends StatefulWidget {
  final User user;
  final int totalpayable;

  const PaymentRoute({Key? key, required this.user, required this.totalpayable})
      : super(key: key);

  @override
  State<PaymentRoute> createState() => _PaymentRouteState();
}

class _PaymentRouteState extends State<PaymentRoute> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: ENV.address +
                    '/api/payment.php?email=' +
                    widget.user.email.toString() +
                    '&mobile=' +
                    widget.user.phone.toString() +
                    '&name=' +
                    widget.user.username.toString() +
                    '&amount=' +
                    widget.totalpayable.toString() +
                    '&userId=' +
                    widget.user.id.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
