import 'package:calories_tracker/Bloc/MainBloc/MainBloc.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainEvent.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainState.dart';
import 'package:calories_tracker/Component/ListTextField.dart';
import 'package:calories_tracker/Component/Spinner.dart';
import 'package:calories_tracker/Constant_Value/AppColor.dart';
import 'package:calories_tracker/Model/UserModel.dart';
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
  var formKey = GlobalKey<FormState>();
  bool isLoadingLogin = false;

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
    if (state is GetUserInitState) {
      isLoadingLogin = false;
    }
    else if (state is GetUserLoadingState) {
      isLoadingLogin = true;
    }
    else if (state is GetUserLoadedState) {
      userModel = state.user;
      await setSharedPref();
      context.read<MainBloc>().add(MainParam.NavToUser(eventStatus: MainEvent.Event_Nav_User, context: context, user: userModel));
      isLoadingLogin = false;
    }
    else if (state is GetUserErrorState) {
      isLoadingLogin = false;
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
                color: const Color(calTracker_White),
                child:
                //mainBody()
                Form(
                  key: formKey,
                  child: mainBody(),
                )
            );
          }),
        ));
  }

  Widget mainBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text(
                    "Welcome To Calories Tracker",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: const Text(
                  "Please Sign To Continue",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(calTracker_Gray)
                  ),
                ),
              ),
              Custom_ListTile_TextField(
                  read: false,
                  controller: eTUserName,
                  labelText: "Username",
                  isMask: false,
                  isNumber:false,
                  mask: false,
                  icon: const Icon(Icons.verified_user),
                  validations: (value) {
                    if(eTUserName.text.isNotEmpty) {
                      return null;
                    } else {
                      return "Please Provide Username";
                    }
                  },
              ),
              Custom_ListTile_TextField(
                obscureText: true,
                read: false,
                controller: eTPassword,
                labelText: "Password",
                isMask: false,
                isNumber:false,
                mask: false,
                icon: const Icon(Icons.password),
                validations: (value) {
                  if(eTPassword.text.isNotEmpty) {
                    return null;
                  } else {
                    return "Please Provide Password";
                  }
                }
              ),

              isLoadingLogin ? ShareSpinner() : solidButton("Login", "LOGIN"),
              Row(
                mainAxisAlignment: MainAxisAlignment.end ,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Don't have account?",
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                  textButton("create a new account.", "REGISTER"),
                ],
              )
          //    solidButton("Registration", "REGISTER")
            ],

          ),
        ),


      ],
    );
  }

  Widget textButton(String text, String event) {
    return Container(
      child: TextButton(
        style: TextButton.styleFrom(
          // padding: const EdgeInsets.all(16.0),
          primary: const Color(calTracker_LightBlue),
          textStyle: const TextStyle(fontSize: 15),
        ),
        onPressed: solidBtnOnClick(text, event),
        child: Text(text),
      ),
    );
  }

  Widget solidButton(String text, String event) {
    return  Padding(
        padding: EdgeInsets.only(left: 2, right: 2),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // style: style,
              style: ElevatedButton.styleFrom(
                  primary: const Color(calTracker_LightBlue),
                  onPrimary: const Color(calTracker_White),
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                  minimumSize: const Size(0,50) // put the width and height you want
              ),
              onPressed: solidBtnOnClick(text, event),
              child: Text(text),
            )
        ),
    );
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

  Future<void> getSharePref() async {
    final SharedPreferences prefs = await _prefs;
    var uname = prefs.getString("userName");
    var pass = prefs.getString("password");
    try {
      if (uname!.isNotEmpty && pass!.isNotEmpty) {
        authentication(uname, pass);
      }
    } catch(e) {
      print("Shared Pref Not Found");
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


  void toRegistrationView() {
    context.read<MainBloc>().add(MainParam.Event_Nav_Registration(eventStatus: MainEvent.Event_Nav_Registration, context: context));

  }

  void solidButtonEvent(String event) {
    switch (event) {
      case "LOGIN":
        bool val = formKey.currentState!.validate();
        if (val) {
          authentication( eTUserName.text, eTPassword.text);
        }
        break;
      case "REGISTER":
        toRegistrationView();
        break;
      default:
        break;
    }

  }
}
