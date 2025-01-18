import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_legend_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyLegendChart extends StatelessWidget {
  const MyLegendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
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
      ),
    );
  }
}
