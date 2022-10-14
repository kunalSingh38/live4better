import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:live_for_better/constants.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class StudentRegistrationAPI {
  String userId = "";

  Future<List> getSessionList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(URL + "session-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode({"user_id": pref.getString("id").toString()}));
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getSStandardList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(URL + "standard-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode({"user_id": pref.getString("id").toString()}));

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getExpenseList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(URL + "expense-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode({"user_id": pref.getString("id").toString()}));
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getRegisteredStudentList(String status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(jsonEncode(
        {"user_id": pref.getString("id").toString(), "status": status}));

    var response = await http.post(Uri.parse(URL + "volunteer-student-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode(
            {"user_id": pref.getString("id").toString(), "status": status}));
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<Map> getStudentStatusCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(URL + "student-status-count-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode({"user_id": pref.getString("id").toString()}));
    print(jsonDecode(response.body));
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return {};
  }

  Future<Map> getStudentFilledDetails(String studentId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(URL + "get-student-registration-detail");
    print(jsonEncode({
      "user_id": pref.getString("id").toString(),
      "student_id": studentId.toString(),
    }));
    var response =
        await http.post(Uri.parse(URL + "get-student-registration-detail"),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              // 'Authorization': 'Bearer ' + api_token.toString(),
            },
            body: jsonEncode({
              "user_id": pref.getString("id").toString(),
              "student_id": studentId.toString(),
            }));

    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return {};
  }

  Future<List> getStudentPerformanceList(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await http.post(Uri.parse(URL + "student-performance-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode({
          "user_id": pref.getString("id").toString(),
          "student_id": id.toString()
        }));
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }

  Future<List> getStudentQuatar() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await http.post(Uri.parse(URL + "quater-list"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode(
            {"user_id": pref.getString("id").toString(), "student_id": ""}));
    if (jsonDecode(response.body)['ErrorCode'] == 0) {
      return jsonDecode(response.body)['Response'];
    }
    return [];
  }
}
