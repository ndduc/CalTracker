import 'package:calories_tracker/Model/FoodObjectsModel.dart';
import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:calories_tracker/Service/FoodNinjaService.dart';
import 'package:calories_tracker/Service/UserRoutineService.dart';
import 'package:calories_tracker/Service/UserService.dart';

class MainRepository{
  /// FOOD
  Future<FoodObjectsModel>GetFoods(String query) {
    return FoodNinjaService().GetFoods(query);
  }

  /// ROUTINE
  Future<List<RoutineModel>>GetUserRoutine(String userId, String dateTime) {
    return UserRoutineService().GetUserRoutine(userId, dateTime);
  }
  Future<bool>AddRoutine(Map<String, dynamic> param) {
    return UserRoutineService().AddRoutine(param);
  }

  /// USER
  Future<UserModel>GetUser(String userName, String password) {
    return UserService().GetUser(userName, password);
  }
  Future<bool>UpsertUser(Map<String, String> param) {
    return UserService().UpsertUser(param);
  }
  Future<bool>VerifyUserName(String userName) {
    return UserService().VerifyUserName(userName);
  }
}