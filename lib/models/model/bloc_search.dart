import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:strak_shop_project/models/model/product.dart';
import 'package:strak_shop_project/services/service.dart';

class BlocSearch {
  List<Product> _listCurrentSearch = [];

  List<Product> get getListCurrentSearch => _listCurrentSearch;

  final _searchController = StreamController<String>();
  final _stateController = StreamController<List<Product>>.broadcast();
  final _loadingController = StreamController<bool>();

  StreamController<List<Product>> get getStateController => _stateController;

  StreamController<bool> get getLoadingController => _loadingController;

  void addChar(String char) {
    _searchController.sink.add(char);
  }

  BlocSearch() {
    _searchController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((String char) async {
      _loadingController.sink.add(true);
      _listCurrentSearch = await DatabaseService().getProductWithChar(char);
      _stateController.sink.add(_listCurrentSearch);
      _loadingController.sink.add(false);
    });
  }
}
