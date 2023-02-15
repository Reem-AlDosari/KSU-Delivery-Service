import 'dart:async';
import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

import '../../constants/enums.dart';
import '../../utils/fb_collections.dart';

class PaypalServices {
  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
//  String domain = "https://api.paypal.com"; // for production mode
//   String domain = "https://api-m.paypal.com"; // for live mode

  //Sand Box
  String clientId =
      'AayZT9AM136stxcWKoEE-g8wldA4aHh88yzFEVh7uzgc6pvWVzrBkbVHhcct320ds6FSb9EIO_o5seTo';
  String secret =
      'EHNnFNmi0FZwcUpHmPY4zIKKVipaYsWib93_QywvAKr0CiN3EomIBJFtvv3nBH0xceNuPJr0ugA4hiwt';

  ///Live

  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      Uri uri =
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials');
      var response = await client.post(uri);
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      Uri uri2 = Uri.parse("$domain/v1/payments/payment");
      var response = await http.post(uri2,
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      print("payment api response $body");
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String?> executePayment(
    transId,
    url,
    payerId,
    accessToken,
    servicePrice,
    docId,
  ) async {
    try {
      Uri uri = Uri.parse(url);
      var response = await http.post(uri,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        var doc = convert.json.decode(response.body).toString();
        DateTime dateTime = DateTime.now().toLocal();
        double price = double.parse(servicePrice);

        await FBCollections.orders.doc(docId).update({
          'payment_status': PaymentStatus.Paid.index,
        });
        await FirebaseFirestore.instance
            .collection("TransactionHistory")
            .doc(transId.toString())
            .set({
          'pay_id': body['id'],
          'state': body['state'],
          'cart': body['cart'],
          'payment_status': PaymentStatus.Paid.index,
          'paid': true,
          'amount': price,
          'jsondecoded': doc,
        });

        print(response);

        print(body);
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
