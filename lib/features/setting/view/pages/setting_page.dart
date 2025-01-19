import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/services/language_service/language_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.switchLanguage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    onSelected: (value) {
                      LanguageService.instance.changeLanguage(value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text("English"),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text("Tiếng Việt"),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
