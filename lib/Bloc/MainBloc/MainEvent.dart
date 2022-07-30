import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:flutter/cupertino.dart';

enum MainEvent{
  Event_GenericLoading,
  Event_NinjaFood_Get,
  Event_Routine_Add,
  Event_Routine_Get,
  Event_Routine_Delete,
  Event_User_Upsert,
  Event_User_Get,
  Event_User_Verify,

  /// NAVIGATE
  Event_Nav_User,
  Event_Nav_Login,
  Event_Nav_Calo,
  Event_Nav_Logout, /// Clear UserModel Data and Clear Shared Pref
  Event_Nav_Registration,

  /// Simple State Event
  Event_Widget_State_Bool,
  Event_Widget_State_Integer
}

class MainParam {
  MainEvent? eventStatus;
  late UserModel user;
  late RoutineModel routine;
  late Map<String, dynamic> param;
  late BuildContext context;
  late bool stateBool;
  late int stateInt;

  MainParam.GenericLoading({required this.eventStatus});
  MainParam.GetFood({required this.eventStatus, required this.param});
  MainParam.AddRoutine({required this.eventStatus, required this.routine});
  MainParam.DeleteRoutine({required this.eventStatus, required this.routine});
  MainParam.GetRoutine({required this.eventStatus, required this.param});
  MainParam.GetUser({required this.eventStatus, required this.param});
  MainParam.UpsertUser({required this.eventStatus, required this.user});
  MainParam.VerifyUser({required this.eventStatus, required this.param});

  MainParam.NavToUser({required this.eventStatus, required this.context, required this.user});
  MainParam.NavToCalo({required this.eventStatus, required this.context, required this.user});
  MainParam.NavToLogout({required this.eventStatus, required this.context});
  MainParam.Event_Nav_Registration({required this.eventStatus, required this.context});


  MainParam.WidgetStateBool({required this.eventStatus, required this.stateBool});
  MainParam.WidgetStateInt({required this.eventStatus, required this.stateInt});
}