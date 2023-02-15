import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/services/paypal_payment/pay_pal.dart';
import 'package:kcds/src/base/customer/order/view_model/order_vm.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../src/base/customer/order/model/order.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final String docId;
  final Order order;
  final String transId;
  PaypalPayment({
    required this.docId,
    required this.transId,
    required this.order,
    required this.onFinish,
  });

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    print("order id ${widget.order.id}");
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = (await services.getAccessToken())!;

        print('papypal accesss token:$accessToken');
        final transactions = getOrderParams(widget.order);
        print('its transaction :$transactions');
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"] ?? "";
            executeUrl = res["executeUrl"] ?? "";
          });
        }
      } catch (e) {
        print('payment exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  int quantity = 1;

  Map<String, dynamic> getOrderParams(Order order) {
    Map<String, dynamic> item = {
      "name": 'order payment',
      "currency": defaultCurrency["currency"]
    };

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.order.price ?? '0',
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": widget.order.price ?? '0',
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "order": item,
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios_rounded),
              onTap: () {
                Provider.of<OrderVM>(context, listen: false).stopLoader();
                Get.back();
                // ShowMessage.inSnackBar(
                //     'Booking Created', "Booking created without payment");
              }),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(
                  widget.transId,
                  executeUrl,
                  payerID,
                  accessToken,
                  widget.order.price,
                  widget.docId,
                )
                    .then((id) {
                  widget.onFinish(id);
                });
              } else {
                // Provider.of<AppProvider>(context, listen: false).stopLoader();
                Get.back();
              }
              // Provider.of<AppProvider>(context, listen: false).stopLoader();
              Get.back();
            }
            if (request.url.contains(cancelURL)) {
              // Provider.of<AppProvider>(context, listen: false).stopLoader();
              Get.back();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
