import 'dart:developer';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';

Future<List<int?>> myDateTimeSelect(BuildContext context) async {
  final result = await showBoardDateTimeMultiPicker(
    context: context,
    pickerType: DateTimePickerType.datetime,
  );

  int? startTime;
  int? due;

  // if datetime is not set
  if (result == null) {
    // throw exception
    throw (myDateTimeException[0].toString());
  }

  startTime = result.start.millisecondsSinceEpoch;
  due = result.end.millisecondsSinceEpoch;

  // selected time must be greater than or equal to the current time
  if (DateTime.fromMillisecondsSinceEpoch(startTime)
              .compareTo(DateTime.now()) ==
          -1 ||
      DateTime.fromMillisecondsSinceEpoch(due).compareTo(DateTime.now()) ==
          -1) {
    log("Selected time must be equal or greater than current time");
    if (context.mounted) {
      MySnackBar(
          context, "Selected time must be equal or greater than current time");
    }
    throw (myDateTimeException[1].toString());
  }

  // if startTime > due => show error and reselect
  if (DateTime.fromMillisecondsSinceEpoch(startTime)
          .compareTo(DateTime.fromMillisecondsSinceEpoch(due)) ==
      1) {
    log("Start time must be equal or greater than end time");
    if (context.mounted) {
      MySnackBar(context, "Start time must be equal or greater than end time");
    }
    throw (myDateTimeException[2].toString());
  }

  return [startTime, due];
}
