import 'package:anilist_manga/provider/anilist_provider.dart';
import 'package:flutter/material.dart';

class MangaProvider with ChangeNotifier {
  final JikanService _jikanService = JikanService();
  List<dynamic> _mangaList = [];
  bool _isLoading = true;

  List<dynamic> get mangaList => _mangaList;
  bool get isLoading => _isLoading;

  Future<void> fetchManga() async {
    _isLoading = true;
    notifyListeners();

    _mangaList = await _jikanService.fetchManga();

    _isLoading = false;
    notifyListeners();
  }

  List<dynamic> getOvaList() {
    return _mangaList.where((manga) => manga['type'] == 'OVA').toList();
  }
}
