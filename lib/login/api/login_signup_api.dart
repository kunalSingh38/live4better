// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:live_for_better/common_widgets.dart';
import 'package:live_for_better/constants.dart';
import 'package:path/path.dart' as p;

class LoginSignUpAPI {
  Future<List> getIdentityProofListAPI() async {
    var response = await http.post(
      Uri.parse(URL + "identity-proof-list"),
      headers: {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ' + api_token.toString(),
      },
    );
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  // Future<Map> saveSignUpDataWeb(
  //   String firstName,
  //   String lastName,
  //   String emailId,
  //   String mobileNumber,
  //   String address,
  //   String photoIdType,
  //   String profilePhotoPath,
  //   String photoIdPath,
  //   String addressIdPath,
  // ) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(URL + "signup-web"));
  //   request.headers.addAll({
  //     'Accept': 'application/json',
  //     // 'Authorization': 'Bearer ' + api_token.toString(),
  //   });

  //   request.fields["first_name"] = firstName.toString();
  //   request.fields["last_name"] = lastName.toString();
  //   request.fields["email"] = emailId.toString();
  //   request.fields["mobile"] = mobileNumber.toString();
  //   request.fields["address"] = address.toString();
  //   request.fields["photo_proof_type"] = photoIdType.toString();
  //   request.fields["photo_proof_image"] = photoIdPath.toString();
  //   request.fields["address_proof_type"] = "1";
  //   request.fields["address_proof_image"] = addressIdPath.toString();
  //   request.fields["profile_pic"] = profilePhotoPath.toString();

  //   var response = await request.send();
  //   var respStr = await response.stream.bytesToString();
  //   print(respStr);
  //   if (jsonDecode(respStr)['ErrorCode'] == 0) {
  //     return jsonDecode(respStr)['Response'];
  //   }

  //   return {};
  // }

  Future<Map> signupOTPVerification(String OTP, String userId) async {
    print(jsonEncode({"user_id": userId.toString(), "otp": OTP.toString()}));

    var response =
        await http.post(Uri.parse(URL + "registration-verify-otp"), headers: {
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ' + api_token.toString(),
    }, body: {
      "user_id": userId.toString(),
      "otp": OTP.toString()
    });

    return jsonDecode(response.body);
  }

  Future<Map> loginOTPVerification(
      String OTP, String userId, String fcm) async {
    print(jsonEncode({
      "user_id": userId.toString(),
      "otp": OTP.toString(),
      "fcm_token": fcm
    }));
    var response =
        await http.post(Uri.parse(URL + "login-verify-otp"), headers: {
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ' + api_token.toString(),
    }, body: {
      "user_id": userId.toString(),
      "otp": OTP.toString(),
      "fcm_token": fcm
    });

    return jsonDecode(response.body);
  }

  Future<String> resendOTP(String phoneNumber, String userId) async {
    var response = await http.post(Uri.parse(URL + "resend-otp"), headers: {
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ' + api_token.toString(),
    }, body: {
      "phone": phoneNumber.toString(),
      "user_id": userId.toString()
    });
    // print(response.body);
    return jsonDecode(response.body)['Response']['otp'].toString();
  }

  Future<Map> loginUser(String phoneNumber) async {
    var response = await http.post(Uri.parse(URL + "login"), headers: {
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ' + api_token.toString(),
    }, body: {
      "phone": phoneNumber.toString(),
    });
    print(response.body);
    return jsonDecode(response.body);
  }
}
