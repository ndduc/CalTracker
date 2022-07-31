import 'package:calories_tracker/Bloc/MainBloc/MainBloc.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainEvent.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainState.dart';
import 'package:calories_tracker/Component/ListTextField.dart';
import 'package:calories_tracker/Component/Spinner.dart';
import 'package:calories_tracker/Helper/StringHelper.dart';
import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:calories_tracker/View/Calo/UpsertCalView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracker/Helper/ChartColorExtension.dart';
import 'package:calories_tracker/Helper/ChartHelper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant_Value/AppColor.dart';

class UserRegistrationView extends StatefulWidget {
  UserRegistrationView({Key? key}) : super(key: key);
  @override
  _View createState() => _View();
}
class _View extends State<UserRegistrationView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late UserModel userModel;
  TextEditingController eTUserName = TextEditingController();
  TextEditingController eTPassword = TextEditingController();
  TextEditingController eTLimitCal = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isLoadingSignUp = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }


  void appBaseEvent(MainState state) {
    if (state is GenericInitialState) {

    } else if (state is GenericLoadingState) {
    } else if (state is GenericLoadedState) {
    } else if (state is GenericErrorState) {
    }
  }


  void appUserEvent(MainState state) {
    if (state is UpsertUserInitState) {
      isLoadingSignUp = false;
    } else if (state is UpsertUserLoadingState) {
      isLoadingSignUp = true;
    } else if (state is UpsertUserLoadedState) {
      /// If registration is a success then direct to UserView
      isLoadingSignUp = true;
      authentication();
    } else if (
    state is UpsertUserErrorState) {
      isLoadingSignUp = false;
      print(state.error);
    }

    else if (state is GetUserInitState) {
      isLoadingSignUp = true;
    }
    else if (state is GetUserLoadingState) {
      isLoadingSignUp = true;
    }
    else if (state is GetUserLoadedState) {
      userModel = state.user;
      setSharedPref();
      context.read<MainBloc>().add(MainParam.NavToUser(eventStatus: MainEvent.Event_Nav_User, context: context, user: userModel));
      isLoadingSignUp = false;
    }
    else if (state is GetUserErrorState) {
      isLoadingSignUp = false;
      print(state.error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocBuilder<MainBloc,MainState>(builder: (BuildContext context,MainState state) {
            /**
             * BLoc Action Note
             * START
             * */
            appBaseEvent(state);
            appUserEvent(state);
            /**
             * Bloc Action Note
             * END
             * */
            return Container(
                padding: const EdgeInsets.only(top: 53, bottom: 30, left: 8, right: 8),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color(calTracker_White),
                    // border: Border(
                    //     left: BorderSide(
                    //         color: Color(calTracker_LightBlue),
                    //         width: 5
                    //     )
                    // )
                ),
                child:
                // mainBody()
                Form(
                  key: formKey,
                  child: mainBody(),
                )
            );
          }),
        ));
  }

  Widget mainBody() {
    return Stack(
      children: [
        inputCard(),
        Align(
          alignment: Alignment.bottomCenter,
          child: isLoadingSignUp ? ShareSpinner()  :  Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              solidButton("Sign Up", "REGISTRATION"),
              solidButton("Go Back", "LOGOUT"),
            ],
          ),
        ),
      ],
    );
  }

  Widget inputCard() {
    return Container(
      child: Column(
        children: [
          UserInfo0(),
          UserInfo1()
        ],
      ),
    );
  }


  Widget UserInfo0() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Custom_ListTile_TextField(
            read: false,
            controller: eTUserName,
            labelText: "Username",
            isMask: false,
            isNumber:false,
            mask: false,
            validations: (value) {
              if(eTUserName.text.isNotEmpty) {
                return null;
              } else {
                return "Please Provide Username";
              }
            },
          ),
        ),
        Expanded(
            flex: 5,
            child: Custom_ListTile_TextField(
                read: false,
                controller: eTPassword,
                labelText: "Password",
                isMask: false,
                isNumber:false,
                mask: false,
                validations: (value) {
                  if(eTPassword.text.isNotEmpty) {
                    return null;
                  } else {
                    return "Please Provide Password";
                  }
                },
            )
        ),
      ],
    );
  }

  Widget UserInfo1() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Custom_ListTile_TextField(
        read: false,
        controller: eTLimitCal,
        labelText: "Limit Daily Calories",
        isMask: false,
        isNumber:true,
        mask: false,
        validations: (value) {
          if(eTLimitCal.text.isNotEmpty) {
            return null;
          } else {
            return "Please Provide Your Daily Calories Limit";
          }
        },
      ),
    );
  }


  Widget solidButton(String text, String event) {
    return Container(
        padding: EdgeInsets.all(2),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(

          // style: style,
          style: ElevatedButton.styleFrom(

              minimumSize: const Size(0,50) // put the width and height you want
          ),
          onPressed: solidBtnOnClick(text, event),
          child: Text(text),
        )
    ) ;
  }

  VoidCallback? solidBtnOnClick(String text, String event) {
    return () {
      solidButtonEvent(event);
    };
  }

  void solidButtonEvent(String event) {
    switch (event) {
      case "REGISTRATION":
        // userModel = UserModel();
        // userModel.userName = eTUserName.text;
        // userModel.password = eTPassword.text;
        // userModel.dailyCaloriesLimit = double.parse(eTLimitCal.text);
        // context.read<MainBloc>().add(MainParam.UpsertUser(eventStatus: MainEvent.Event_User_Upsert, user: userModel));
        bool val = formKey.currentState!.validate();
        if(val) {
          userModel = UserModel();
          userModel.userName = eTUserName.text;
          userModel.password = eTPassword.text;
          userModel.dailyCaloriesLimit = double.parse(eTLimitCal.text);
          context.read<MainBloc>().add(MainParam.UpsertUser(eventStatus: MainEvent.Event_User_Upsert, user: userModel));
        }
        break;
      case "LOGOUT":
        context.read<MainBloc>().add(MainParam.NavToLogout(eventStatus: MainEvent.Event_Nav_Logout, context: context));
        break;
      default:
        break;
    }

  }

  Future<void> setSharedPref()  async {
    final SharedPreferences prefs = await _prefs;
    if(userModel.isActive) {
      prefs.setString("userName", userModel.userName);
      prefs.setString("password", userModel.password);
      prefs.setString("userId", userModel.userId);
      prefs.setBool("isActive", userModel.isActive);
      prefs.setBool("loginPersistence", userModel.loginPersistence);
      prefs.setString("created", userModel.created.toString());
      prefs.setString("updated", userModel.updated.toString());
      prefs.setString("dailyCaloriesLimit", userModel.dailyCaloriesLimit.toString());
    }
  }

  void authentication() {
    var param = <String, dynamic>{
      "user": userModel.userName,
      "password": userModel.password
    };
    context.read<MainBloc>().add(MainParam.GetUser(eventStatus: MainEvent.Event_User_Get, param: param));
  }


  void toRegistrationView() {
    context.read<MainBloc>().add(MainParam.Event_Nav_Registration(eventStatus: MainEvent.Event_Nav_Registration, context: context));

  }




}