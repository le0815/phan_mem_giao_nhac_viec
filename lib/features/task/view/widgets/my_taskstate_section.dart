import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/pages/detail_task_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTaskstateSection extends StatelessWidget {
  const MyTaskstateSection({
    super.key,
    required this.isComplete,
    required this.onTap,
  });
  final bool isComplete;

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.taskState,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isComplete
                        ? ThemeConfig.primaryColor
                        : ThemeConfig.secondaryColor,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.completed,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: isComplete ? Colors.white : Colors.black,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
