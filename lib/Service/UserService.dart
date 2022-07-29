import 'dart:convert';

import 'package:calories_tracker/Model/FoodObjectsModel.dart';
import 'package:calories_tracker/Constant/Api/ApiValue.dart';
import 'package:calories_tracker/Constant/Api/ApiHelper.dart';
import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:http/http.dart' as http;

abstract class Service{
  Future<UserModel>GetUser(String userName, String password);
  Future<bool>UpsertUser(Map<String, String> param);
  Future<bool>VerifyUserName(String userName);
}

class UserService extends Service {
  @override
  Future<UserModel>GetUser(String userName, String password) async {
    try {
      var url = Uri.parse(HOST + USER_ENDPOINT + "Get?user=" + userName + "&password=" + password);
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        return UserModel.map(json);
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool>UpsertUser(Map<String, String> param) async {
    try {
      var url = Uri.parse(HOST + USER_ENDPOINT + "Save");
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: param
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        String response = json[BODY];
        if (response == OK) {
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
  Future<bool>VerifyUserName(String userName) async {
    try {
      var url = Uri.parse(HOST + USER_ENDPOINT + "Verify?user=" + userName);
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        String response = json[BODY];
        if (response == OK) {
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