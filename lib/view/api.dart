import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:live_for_better/constants.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class DonationAPI {
  String userId = "";

  Future<List> getDonationReceiptList(String mobile, String pan) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(URL + "donation-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode(
            {"mobile": mobile.toString(), "pan_number": pan.toString()}));
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<Map> getReceiptDetails(String paymentId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(URL + "donation-detail"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode({"payment_id": paymentId.toString()}));
    print(URL + "donation-detail");
    print(paymentId);
    print(response.body);
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return {};
  }

  Future<List> getDonationNatureList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(URL + "nature-of-donation-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode({
          "user_id": pref.getString("id").toString(),
        }));
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }
}
