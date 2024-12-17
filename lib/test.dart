import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

scheduleBackgroundNotify(DateTime time) async {
  print("start time: $time");
  print("start time utc: ${time.toUtc()}");
  print(
      "tz time: ${tz.TZDateTime.from(time.toUtc(), tz.getLocation("Asia/Ho_Chi_Minh"))}");
  print("creating background notify");
}

void main() async {
  await tz.initializeTimeZone();

  var time = DateTime.now();
  scheduleBackgroundNotify(time);
  // Map locations = tz.timeZoneDatabase.locations;
  // locations.forEach(
  //   (key, value) {
  //     print("$key - $value");
  //   },
  // );
  // print(locations.length); // => 429
  // print(locations.keys.first); // => "Africa/Abidjan"
  // print(locations.keys.last);
}
