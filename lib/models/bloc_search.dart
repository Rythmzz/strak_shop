import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:strak_shop_project/models/product.dart';
import 'package:strak_shop_project/services/database.dart';

class BlocSearch{
  List<Product> _listCurrentSearch =[];
  List<Product> get getListCurrentSearch => _listCurrentSearch;


  final _searchController = StreamController<String>();
  final _stateController = StreamController<List<Product>>.broadcast();
  StreamController<List<Product>> get getStateController => _stateController;

  void addChar(String char){
    _searchController.sink.add(char);
  }

  BlocSearch(){
    _searchController.stream.debounceTime(Duration(milliseconds: 500)).listen((String char) async {
      print("Current Search After 2 Seconds: $char");
      _listCurrentSearch = await DatabaseService().getProductWithChar(char);
      _stateController.sink.add(_listCurrentSearch);
    });
  }


}