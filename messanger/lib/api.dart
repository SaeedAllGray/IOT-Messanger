import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  // static sendGETRequest() async {
  //   http.Response response =
  //       await http.get(Uri.parse('http://192.168.1.134/gif'));
  //   print(response.body);
  // }

  // static sendPostRequest() async {
  //   http.Response response = await http
  //       .post(Uri.parse('http://192.168.1.134'), headers: {"name": "saeed"});
  //   print(response.body);
  // }

  static _ledOn() async {
    try {
      http.Response response =
          await http.get(Uri.parse('http://192.168.1.134/ledon'));
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  static _ledOff() async {
    try {
      http.Response response =
          await http.get(Uri.parse('http://192.168.1.134/ledoff'));
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  static toggleLED(bool value) async {
    if (value) {
      _ledOn();
    } else {
      _ledOff();
    }
  }

  static sendMessage(String message) async {
    String name = await getName();
    try {
      http.Response response = await http.get(
          Uri.parse('http://192.168.1.134/send?from=$name&message=$message'));
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  static deleteHisory() async {
    try {
      http.Response response =
          await http.get(Uri.parse('http://192.168.1.134/removehistory'));
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  static Future<List<String>> recieveMessages() async {
    try {
      http.Response response =
          await http.get(Uri.parse('http://192.168.1.134/gethistory'));
      print(response.body);
      return _getHistory(response.body);
    } catch (e) {
      print(e);
    }
    return [];
  }

  static Future<List<dynamic>> getPinsStatus() async {
    try {
      http.Response response =
          await http.get(Uri.parse('http://192.168.1.134/getpinsstatus'));
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return [];
    }
  }

  static List<String> _getHistory(String messages) {
    List<String> history = [];
    int j = 0;
    for (var i = 0; i < messages.length; i++) {
      if (messages[i] == '\n') {
        history.add(messages.substring(j, i));
        j = i;
      }
    }
    return history;
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'unknown';
  }
}
