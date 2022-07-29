import 'package:calories_tracker/Model/FoodObjectsModel.dart';
import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// Must have on every screen
//region GENERIC STATE
class GenericInitialState extends MainState{ }
class GenericLoadingState extends MainState{ }
class GenericLoadedState extends MainState{
  bool genericBool = false;
  int genericInt = 0;
  GenericLoadedState({required this.genericBool});
  GenericLoadedState.Integer({required this.genericInt});
}
class GenericErrorState extends MainState{
  final error;
  GenericErrorState({this.error});
}

/// FOOD STATE
/// Get Food
class GetFoodInitState extends MainState {}
class GetFoodLoadingState extends MainState {}
class GetFoodLoadedState extends MainState {
  FoodObjectsModel foods;
  GetFoodLoadedState({required this.foods});
}
class GetFoodErrorState extends MainState {
  final error;
  GetFoodErrorState({this.error});
}

/// ROUTINE STATE
/// Get Routine
class GetRoutineInitState extends MainState {}
class GetRoutineLoadingState extends MainState {}
class GetRoutineLoadedState extends MainState {
  List<RoutineModel> routines;
  GetRoutineLoadedState({required this.routines});
}
class GetRoutineErrorState extends MainState {
  final error;
  GetRoutineErrorState({this.error});
}
/// Add Routine
class AddRoutineInitState extends MainState {}
class AddRoutineLoadingState extends MainState {}
class AddRoutineLoadedState extends MainState {
  late bool isSucessful;
  AddRoutineLoadedState({required this.isSucessful});
}
class AddRoutineErrorState extends MainState {
  final error;
  AddRoutineErrorState({this.error});
}

/// USER STATE
/// Get User
class GetUserInitState extends MainState {}
class GetUserLoadingState extends MainState {}
class GetUserLoadedState extends MainState {
  UserModel user;
  GetUserLoadedState({required this.user});
}
class GetUserErrorState extends MainState {
  final error;
  GetUserErrorState({this.error});
}

/// Verify User
class VerifyUserInitState extends MainState {}
class VerifyUserLoadingState extends MainState {}
class VerifyUserLoadedState extends MainState {
  late bool isExist;
  VerifyUserLoadedState({required this.isExist});
}
class VerifyUserErrorState extends MainState {
  final error;
  VerifyUserErrorState({this.error});
}

/// Upsert User
class UpsertUserInitState extends MainState {}
class UpsertUserLoadingState extends MainState {}
class UpsertUserLoadedState extends MainState {
  late bool isSucessful;
  UpsertUserLoadedState({required this.isSucessful});
}
class UpsertUserErrorState extends MainState {
  final error;
  UpsertUserErrorState({this.error});
}