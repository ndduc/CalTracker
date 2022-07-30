import 'package:calories_tracker/Bloc/MainBloc/MainBloc.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainEvent.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainState.dart';
import 'package:calories_tracker/Component/ListTextField.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Constant_Value/AppColor.dart';

class UserUpdateView extends StatefulWidget {
  UserModel userModel;
  UserUpdateView({Key? key, required this.userModel}) : super(key: key);
  @override
  _View createState() => _View();
}
class _View extends State<UserUpdateView> {
  late UserModel userModel;
  TextEditingController eTUserId = TextEditingController();
  TextEditingController eTUserName = TextEditingController();
  TextEditingController eTPassword = TextEditingController();
  TextEditingController eTLimitCal = TextEditingController();
  TextEditingController eTApiKey_AWS = TextEditingController();
  TextEditingController eTCreatedDatetime = TextEditingController();
  TextEditingController eTUpdateDatetime = TextEditingController();
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    setControllerValue();
  }

  void setControllerValue() {
    eTUserId.text = userModel.userId;
    eTUserName.text = userModel.userName;
    eTPassword.text = userModel.password;
    eTLimitCal.text = userModel.dailyCaloriesLimit.toString();
    eTApiKey_AWS.text = "Not Implemented";
    eTCreatedDatetime.text = userModel.created.toString();
    eTUpdateDatetime.text = userModel.updated.toString();
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

    } else if (state is UpsertUserLoadingState) {
    } else if (state is UpsertUserLoadedState) {
      userModel = state.model;
      widget.userModel = state.model;
    } else if (state is UpsertUserErrorState) {
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
                padding: const EdgeInsets.only(top: 53, bottom: 8, left: 8, right: 8),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color(calTracker_White),
                    border: Border(
                        left: BorderSide(
                            color: Color(calTracker_LightBlue),
                            width: 5
                        )
                    )
                ),
            child: mainBody());
          }),
        ));
  }

  Widget mainBody() {
    return Stack(
      children: [
        inputCard(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              solidButton("Save", "SAVE"),
              solidButton("Logout", "LOGOUT"),
            ],
          )
        ),
      ],
    );
  }

  Widget inputCard() {
    return Container(
      child: Column(
        children: [
          UserInfo0(),
          UserInfo1(),
          UserInfo2(),
          UserInfo3(),
          UserInfo4(),
          UserInfo5(),
        ],
      ),
    );
  }

  Widget UserInfo0() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Custom_ListTile_TextField(
        read: true,
        controller: eTUserId,
        labelText: "User Id",
        isMask: false,
        isNumber:true,
        mask: false,
      ),
    );
  }
  Widget UserInfo1() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Custom_ListTile_TextField(
            read: true,
            controller: eTUserName,
            labelText: "Username",
            isMask: false,
            isNumber:false,
            mask: false,
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
                mask: false
            )
        ),
      ],
    );
  }

  Widget UserInfo2() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Custom_ListTile_TextField(
        read: false,
        controller: eTLimitCal,
        labelText: "Limit Daily Calories",
        isMask: false,
        isNumber:true,
        mask: false,
      ),
    );
  }

  Widget UserInfo3() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Custom_ListTile_TextField(
        read: true,
        controller: eTApiKey_AWS,
        labelText: "API Key",
        isMask: false,
        isNumber:true,
        mask: false,
      ),
    );
  }

  Widget UserInfo4() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Custom_ListTile_TextField(
        read: true,
        controller: eTCreatedDatetime,
        labelText: "User - Created Datetime",
        isMask: false,
        isNumber:true,
        mask: false,
      ),
    );
  }

  Widget UserInfo5() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Custom_ListTile_TextField(
        read: true,
        controller: eTUpdateDatetime,
        labelText: "User - Updated Datetime",
        isMask: false,
        isNumber:true,
        mask: false,
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
      case "SAVE":
        userModel.password = eTPassword.text;
        userModel.dailyCaloriesLimit = double.parse(eTLimitCal.text);
        context.read<MainBloc>().add(MainParam.UpsertUser(eventStatus: MainEvent.Event_User_Upsert, user: userModel));
        break;
      case "LOGOUT":
        context.read<MainBloc>().add(MainParam.NavToLogout(eventStatus: MainEvent.Event_Nav_Logout, context: context));
        break;
      default:
        break;
    }

  }




}