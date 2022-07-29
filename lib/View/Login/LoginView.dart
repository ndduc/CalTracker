import 'package:calories_tracker/Bloc/MainBloc/MainBloc.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainEvent.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainState.dart';
import 'package:calories_tracker/Component/ListTextField.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);
  @override
  _View createState() => _View();
}

class _View extends State<LoginView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController eTUserName = TextEditingController();
  TextEditingController eTPassword = TextEditingController();
  late UserModel userModel;
  @override
  void initState() {
    super.initState();
    getSharePref();
  }

  @override
  dispose() {
    super.dispose();
  }

  void appBaseEvent(MainState state) {
    // Executing Generic State
    if (state is GenericInitialState) {
    } else if (state is GenericLoadingState) {
    } else if (state is GenericErrorState) {
    }
  }

  Future<void> appUserEvent(MainState state) async {
    if (state is GetUserInitState) {}
    else if (state is GetUserLoadingState) {}
    else if (state is GetUserLoadedState) {
      userModel = state.user;
      await setSharedPref();
      context.read<MainBloc>().add(MainParam.NavToUser(eventStatus: MainEvent.Event_Nav_User, context: context, user: userModel));

    }
    else if (state is GetUserErrorState) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
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
                padding: EdgeInsets.only(top: 50),
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage(uImage.mapImage['bg-3']),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: mainBody());
          }),
        ));
  }

  Widget mainBody() {
    return Column(
      children: [
        Custom_ListTile_TextField(
            read: false,
            controller: eTUserName,
            labelText: "UserName",
            isMask: false,
            isNumber:false,
            mask: false
        ),
        Custom_ListTile_TextField(
            obscureText: true,
            read: false,
            controller: eTPassword,
            labelText: "Password",
            isMask: false,
            isNumber:false,
            mask: false
        ),
        solidButton("ENTER", "HIT")
      ],
    );
  }


  Widget solidButton(String text, String event) {
    return ListTile(
        title: ElevatedButton(

          // style: style,
          style: ElevatedButton.styleFrom(

              minimumSize: const Size(0,50) // put the width and height you want
          ),
          onPressed: solidBtnOnClick(text, event),
          child: Text(text),
        )
    ) ;
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
    }
  }

  Future<void> getSharePref() async {
    final SharedPreferences prefs = await _prefs;
    var uname = prefs.getString("userName");
    var pass = prefs.getString("password");

    if (uname!.isNotEmpty && pass!.isNotEmpty) {
      authentication(uname, pass);
    }
  }

  VoidCallback? solidBtnOnClick(String text, String event) {
    return () {
      solidButtonEvent(event);
    };
  }

  void authentication(String user, String pass) {
    var param = <String, dynamic>{
      "user": user,
      "password": pass
    };

    context.read<MainBloc>().add(MainParam.GetUser(eventStatus: MainEvent.Event_User_Get, param: param));

  }
  void solidButtonEvent(String event) {
    switch (event) {
      case "HIT":
        authentication( eTUserName.text, eTPassword.text);
        break;
      default:
        break;
    }

  }
}
