import 'dart:convert';

import 'package:calories_tracker/Model/FoodObjectsModel.dart';
import 'package:calories_tracker/Constant/Api/ApiValue.dart';
import 'package:calories_tracker/Constant/Api/ApiHelper.dart';
import 'package:http/http.dart' as http;

abstract class Service{
  Future<FoodObjectsModel>GetFoods(String query);
}

class FoodNinjaService extends Service {
  @override
  Future<FoodObjectsModel>GetFoods(String query) async {
    try {
      var url = Uri.parse(HOST + NINJA_ENDPOINT + "Food?query=" + query);
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        return FoodObjectsModel(json) ;
      }
    } catch(e) {
      throw Exception(e);
    }
  }
}