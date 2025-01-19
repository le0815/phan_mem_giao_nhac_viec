import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_datetime_result.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view_model/task_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatetimeSection extends StatefulWidget {
  DatetimeSection({
    super.key,
    this.isAddTaskPage = false,
    required this.pageWidget,
  });

  final pageWidget;
  bool isAddTaskPage;
  @override
  State<DatetimeSection> createState() => _DatetimeSectionState();
}

class _DatetimeSectionState extends State<DatetimeSection> {
  @override
  Widget build(BuildContext context) {
    GetDates() async {
      try {
        final result = await showBoardDateTimeMultiPicker(
          context: context,
          pickerType: DateTimePickerType.datetime,
        );
        var resultValidated = TaskViewModel.instance
            .dateTimeValidate(startTime: result?.start, due: result?.end);
        widget.pageWidget.startTime = resultValidated[0];
        widget.pageWidget.due = resultValidated[1];
      } catch (e) {
        // if datetime was not set => switch back to screen
        if (e.toString() == myDateTimeException[1].toString()) {
          if (context.mounted) {
            MySnackBar(context,
                "Selected time must be equal or greater than current time");
          }
          await GetDates();
        }
        // if datetime was not set => switch back to screen
        if (e.toString() == myDateTimeException[2].toString()) {
          if (context.mounted) {
            MySnackBar(
                context, "Start time must be equal or greater than end time");
          }
          await GetDates();
        }
      }
      setState(() {});
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              AppLocalizations.of(context)!.schedule,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        GestureDetector(
          onTap: () async {
            await GetDates();
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: MyDatetimeResult(
                  newTime: widget.pageWidget.startTime,
                  oldTime: widget.isAddTaskPage
                      ? null
                      : widget.pageWidget.modelTask.startTime,
                  title: AppLocalizations.of(context)!.startTime,
                ),
              ),
              AddHorizontalSpace(10),
              Expanded(
                child: MyDatetimeResult(
                  newTime: widget.pageWidget.due,
                  oldTime: widget.isAddTaskPage
                      ? null
                      : widget.pageWidget.modelTask.due,
                  title: AppLocalizations.of(context)!.dueTime,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
