import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/features/home/view/widgets/my_pie_chart.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_legend_chart.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // Overview
          OverView(),
        ],
      ),
    );
  }
}

class OverView extends StatefulWidget {
  const OverView({
    super.key,
  });

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.overView,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          height: 400,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: ThemeConfig.secondaryColor,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              const chatLegend(),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable:
                      TaskLocalRepo.instance.taskHiveBox.listenable(),
                  builder: (context, box, child) {
                    if (box.isEmpty) {
                      return Center(
                        child: Text(
                            AppLocalizations.of(context)!.nothingToShowHere),
                      );
                    }
                    var classifiedTask = DatabaseService.instance
                        .taskClassification(data: box.toMap());
                    return MyPieChart(
                      taskData: classifiedTask,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class chatLegend extends StatelessWidget {
  const chatLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myLegendChart(
                annotation: AppLocalizations.of(context)!.pending,
                color: Colors.yellow),
            myLegendChart(
                annotation: AppLocalizations.of(context)!.inProgress,
                color: Colors.blue),
          ],
        ),
        AddHorizontalSpace(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myLegendChart(
                annotation: AppLocalizations.of(context)!.completed,
                color: Colors.green),
            myLegendChart(
                annotation: AppLocalizations.of(context)!.overDue,
                color: Colors.red),
          ],
        ),
      ],
    );
  }
}
