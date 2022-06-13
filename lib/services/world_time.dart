import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {

  String location;
  String time = '';
  String flag;
  String url;
  VoidCallback callback;
  bool isDayTime = true;

  WorldTime({required this.location, required this.flag, required this.url, required this.callback});

  Future<void> getTime() async {
    try {
      Response resp = await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(resp.body);
      String dateTime = data['datetime'];
      String offset = data['utc_offset'].substring(1,3);
      String sign = data['utc_offset'].substring(0,1);
      DateTime now = DateTime.parse(dateTime);
      now = sign == '-' ? now.subtract(Duration(hours: int.parse(offset))) : now.add(Duration(hours: int.parse(offset)));
      time = DateFormat.jm().format(now);
      isDayTime = now.hour > 6 && now.hour < 20;
      callback();
    }
    catch(e) {
      if (kDebugMode) {
        print(e);
      }
      callback();
      time = 'error pa';
    }
  }

}