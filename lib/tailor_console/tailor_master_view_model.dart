import 'package:flutter/material.dart';

class TailorMasterViewModel extends ChangeNotifier {
  int selectedPageIndex = 0;

  int getPageIndex() => selectedPageIndex;

  void onPageUpdated(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }
}
