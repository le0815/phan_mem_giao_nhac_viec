import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';

Future<List<Timestamp?>> myDateTimeSelect(BuildContext context) async {
  List<DateTime>? dateTimeList =
      await showOmniDateTimeRangePicker(context: context);

  Timestamp? startTime;
  Timestamp? due;

  // if datetime is not set
  if (dateTimeList == null) {
    // throw exception
    throw (myDateTimeException[0].toString());
  }

  startTime = Timestamp.fromMillisecondsSinceEpoch(
      dateTimeList[0].millisecondsSinceEpoch);
  due = Timestamp.fromMillisecondsSinceEpoch(
      dateTimeList[1].millisecondsSinceEpoch);

  // selected time must be greater than or equal to the current time
  if (DateTime.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch)
              .compareTo(DateTime.now()) ==
          -1 ||
      DateTime.fromMillisecondsSinceEpoch(due.millisecondsSinceEpoch)
              .compareTo(DateTime.now()) ==
          -1) {
    log("Selected time must be equal or greater than current time");
    if (context.mounted) {
      MySnackBar(
          context, "Selected time must be equal or greater than current time");
    }
    throw (myDateTimeException[1].toString());
  }

  // if startTime > due => show error and reselect
  if (DateTime.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch)
          .compareTo(DateTime.fromMillisecondsSinceEpoch(
              due.millisecondsSinceEpoch)) ==
      1) {
    log("Start time must be equal or greater than end time");
    if (context.mounted) {
      MySnackBar(context, "Start time must be equal or greater than end time");
    }
    throw (myDateTimeException[2].toString());
  }

  return [startTime, due];
}
