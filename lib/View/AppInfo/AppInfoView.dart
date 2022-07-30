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

import '../../Constant_Value/AppColor.dart';

class AppInfoView extends StatefulWidget {
  UserModel userModel;
  AppInfoView({Key? key, required this.userModel}) : super(key: key);
  @override
  _View createState() => _View();
}

class _View extends State<AppInfoView> {
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
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
            /**
             * Bloc Action Note
             * END
             * */
            return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color(calTracker_White)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ Text("APP INFO\nNot Implemented")],
                )
            );
          }),
        ));
  }

}