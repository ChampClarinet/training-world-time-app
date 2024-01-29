import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time = 'loading';
  String flag;
  String url;
  bool isDayTime = false;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      Response response =
          await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);
      String datetime = data['datetime'];
      int offset = int.parse(data['utc_offset'].toString().substring(1, 3));

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: offset));
      time = DateFormat.jm().format(now);
      isDayTime = now.hour > 6 && now.hour < 20;
      debugPrint('offsetted time: $time (${offset >= 0 ? '+' : '-'}$offset)');
    } catch (e) {
      debugPrint('error caught $e');
      time = 'could not get time data';
    }
  }
}
