import 'package:calories_tracker/Bloc/MainBloc/MainEvent.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainState.dart';
import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:calories_tracker/Repository/MainRepos.dart';
import 'package:calories_tracker/View/Calo/UpsertCalView.dart';
import 'package:calories_tracker/View/User/UserView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainBloc extends Bloc<MainParam,MainState>
{
  MainRepository repos;
  MainBloc({required this.repos}) : super(GenericInitialState());

  @override
  Stream<MainState> mapEventToState(MainParam event) async* {

    /// Navigate Switch
    navigateHelper(event);

    switch(event.eventStatus)
    {
      /// GENERIC STTE
      case MainEvent.Event_Widget_State_Bool:
        yield GenericInitialState();
        try {
           yield GenericLoadingState();
           yield GenericLoadedState(genericBool: event.stateBool);
        } catch(e) {
          yield GenericErrorState(error:  e);
        }
        break;
      case MainEvent.Event_Widget_State_Integer:
        yield GenericInitialState();
        try {
          yield GenericLoadingState();
          yield GenericLoadedState.Integer(genericInt: event.stateInt);
        } catch(e) {
          yield GenericErrorState(error:  e);
        }
        break;
      /// FOOD
      case MainEvent.Event_NinjaFood_Get:
        yield GetFoodInitState();
        try {
          yield GetFoodLoadingState();
          Map<String, dynamic> param = event.param as Map<String, dynamic>;
          var res = await repos.GetFoods(param["query"].toString());
          yield GetFoodLoadedState(foods: res);

        } catch (e) {
          yield GetFoodErrorState(error: e);
        }
        break;
      /// ROUTINE
      case MainEvent.Event_Routine_Add:
        yield AddRoutineInitState();
        try {
          yield AddRoutineLoadingState();
          var routine = event.routine;
          Map<String, dynamic> param = routine.toMap();
          var res = await repos.AddRoutine(param);
          yield AddRoutineLoadedState(isSucessful: res);

        } catch (e) {
          yield AddRoutineErrorState(error: e);
        }
        break;
      case MainEvent.Event_Routine_Get:
        yield GetRoutineInitState();
        try {
          yield GetRoutineLoadingState();
          Map<String, dynamic> param = event.param as Map<String, dynamic>;
          var res = await repos.GetUserRoutine(param["userId"].toString(), param["dateTime"].toString());
          yield GetRoutineLoadedState(routines: res);

        } catch (e) {
          yield GetRoutineErrorState(error: e);
        }
        break;
      /// USER
      case MainEvent.Event_User_Upsert:
        yield UpsertUserInitState();
        try {
          yield UpsertUserLoadingState();
        } catch (e) {
          yield UpsertUserErrorState(error: e);
        }
        break;
      case MainEvent.Event_User_Get:
        yield GetUserInitState();
        try {
          yield GetUserLoadingState();
          Map<String, dynamic> param = event.param as Map<String, dynamic>;
          var res = await repos.GetUser(param["user"].toString(), param["password"].toString());
          yield GetUserLoadedState(user: res);
        } catch (e) {
          yield GetUserErrorState(error: e);
        }
        break;
      case MainEvent.Event_User_Verify:
        yield VerifyUserInitState();
        try {
          yield VerifyUserLoadingState();
        } catch (e) {
          yield VerifyUserErrorState(error: e);
        }
        break;
      default:
        break;
    }
  }

  void navigateHelper(MainParam event) {
    switch(event.eventStatus) {
      case MainEvent.Event_Nav_User:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(repos: MainRepository()),
                  child:UserView(userModel: event.user));
            }));
        break;
      case MainEvent.Event_Nav_Calo:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(repos: MainRepository()),
                  child:UpsertCalView(userModel: event.user));
            }));
        break;
      default:
        break;
    };
  }
}