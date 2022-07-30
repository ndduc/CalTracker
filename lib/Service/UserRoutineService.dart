import 'dart:convert';

import 'package:calories_tracker/Model/FoodObjectsModel.dart';
import 'package:calories_tracker/Constant/Api/ApiValue.dart';
import 'package:calories_tracker/Constant/Api/ApiHelper.dart';
import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:http/http.dart' as http;

abstract class Service{
  Future<List<RoutineModel>>GetUserRoutine(String userId, String dateTime);
  Future<bool>AddRoutine(Map<String, dynamic> param);
  Future<bool>DeleteRoutine(Map<String, dynamic> param);
}

class UserRoutineService extends Service {
  @override
  Future<List<RoutineModel>>GetUserRoutine(String userId, String dateTime) async {
    List<RoutineModel> listModel = [];

    try {
      var url = Uri.parse(HOST + ROUTINE_ENDPOINT + "User/Get?date=" + dateTime + "&user=" + userId);
      var res = await http.get(
          url,
          headers: HEADER
      );

      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        for(int i = 0; i < json.length; i++) {
          RoutineModel _model =  RoutineModel.map(json[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<bool>AddRoutine(Map<String, dynamic> param) async {
    try {
      var url = Uri.parse(HOST + ROUTINE_ENDPOINT + "User/Add");
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: jsonEncode(param)
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        if (res.body == OK) {
          return true;
        } else {
          return false;
        }
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool>DeleteRoutine(Map<String, dynamic> param) async {
    try {
      var url = Uri.parse(HOST + ROUTINE_ENDPOINT + "User/Delete");
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: jsonEncode(param)
      );
      print(res.body);
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        if (res.body == OK) {
          return true;
        } else {
          return false;
        }
      }
    } catch(e) {
      throw Exception(e);
    }
  }
}