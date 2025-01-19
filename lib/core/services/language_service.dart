import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService instance = LanguageService._();
  LanguageService._();
  changeLanguage(int value) {
    log("changing language preference");
    notifyListeners();
    LocalRepo.instance.saveUserSetting(
      userSetting: {"language": value},
    );
  }
}
