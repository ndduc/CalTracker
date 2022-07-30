import 'package:calories_tracker/Bloc/MainBloc/MainBloc.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainEvent.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainState.dart';
import 'package:calories_tracker/Component/ListTextField.dart';
import 'package:calories_tracker/Component/Spinner.dart';
import 'package:calories_tracker/Helper/StringHelper.dart';
import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:calories_tracker/View/AppInfo/AppInfoView.dart';
import 'package:calories_tracker/View/Calo/UpsertCalView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracker/Helper/ChartColorExtension.dart';
import 'package:calories_tracker/Helper/ChartHelper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../Constant_Value/AppColor.dart';
import 'UserUpdate.dart';

// ignore: must_be_immutable
class UserView extends StatefulWidget {
  UserModel userModel;
  UserView({Key? key, required this.userModel}) : super(key: key);
  @override
  _View createState() => _View();
}

class _View extends State<UserView> {

  //final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late UserModel userModel;
  List<RoutineModel> routineList = [];

  double totalDailyCal = 0;
  double totalDailyProtein = 0;

  double maxDailyCalories = 0;
  double caloriesRatio = 0;
  double remainingCaloriesRatio = 100;

  /// Bottom Nav Index
  int _selectedIndex = 0;

  /// Chart Index
  int touchedIndex = -1;

  bool isLoading = false;
  bool isLoadingDeleteRoutine = false;

  Map<String, dynamic> colorParam = {};

  setIntakeAndRemainColor() {
    int intakeColor = calTracker_Orange;

    if (caloriesRatio <= 25) {
      intakeColor = calTracker_Orange;
    } else if (caloriesRatio > 25 && caloriesRatio <= 75) {
      intakeColor = calTracker_Green;
    } else {
      intakeColor = calTracker_Red_Warning;
    }

    var intakeCal = caloriesRatio;
    var remainCal = remainingCaloriesRatio;
    if (caloriesRatio > 100) {
      intakeCal = 100;
    }

    if (remainingCaloriesRatio < 0) {
      remainCal = 0;
    }

    colorParam =   {
      "intakeColor":intakeColor,
      "intakeCal":intakeCal,
      "remainCal": remainCal
    };
  }



  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  //  maxDailyCalories = userModel.dailyCaloriesLimit;
    getDailyRoutine();
  }

  @override
  dispose() {
    super.dispose();
  }


  Future<void> getSharedPref()  async {
  }


  void appBaseEvent(MainState state) {
    if (state is GenericInitialState) {

    } else if (state is GenericLoadingState) {
    } else if (state is GenericLoadedState) {
      _selectedIndex = state.genericInt;
      switch(_selectedIndex) {
        case 0:
          getDailyRoutine();
          break;
        case 1:
          break;
        default:
          break;
      }
    } else if (state is GenericErrorState) {
    }
  }

  appUserEvent(MainState state) {
    if (state is GetUserInitState) {}
    else if (state is GetUserLoadingState) {}
    else if (state is GetUserLoadedState) {

    }
    else if (state is GetUserErrorState) {}
  }

  appRoutineEvent(MainState state) {
    if (state is GetRoutineInitState) {
      isLoading = false;
    }
    else if (state is GetRoutineLoadingState) {
      isLoading = true;
    }
    else if (state is GetRoutineLoadedState) {
      maxDailyCalories = userModel.dailyCaloriesLimit;
      routineList = state.routines;
      calculatingConsumingCalories();
      isLoading = false;
    }
    else if (state is GetRoutineErrorState) {
      maxDailyCalories = userModel.dailyCaloriesLimit;
      isLoading = false;
    }
    else if (state is DeleteRoutineInitState) {
      isLoadingDeleteRoutine = false;
    }
    else if (state is DeleteRoutineLoadingState) {
      isLoadingDeleteRoutine = true;
    }
    else if (state is DeleteRoutineLoadedState) {
      for(int i = 0; i < routineList.length; i++) {
        if (routineList[i].routineId == state.deletedRoutineId) {
          routineList.removeAt(i);
        }
      }
      calculatingConsumingCalories();
      setIntakeAndRemainColor();
      isLoadingDeleteRoutine = false;
    }
    else if (state is DeleteRoutineErrorState) {
      isLoadingDeleteRoutine = false;
    }
  }

  void calculatingConsumingCalories() {
    caloriesRatio = 0;
    remainingCaloriesRatio = 100;
    totalDailyCal = 0;
    totalDailyProtein = 0;

    routineList.forEach((item) {
      totalDailyCal += item.totalCalories;
      totalDailyProtein += item.totalProtein;
    });
    calculateDailyRoutineRation();
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
            appRoutineEvent(state);
            /**
             * Bloc Action Note
             * END
             * */
            return Container(
              decoration: const BoxDecoration(
                color: Color(calTracker_White)
              ),
                child: Column(
                  children: [
                    Expanded(
                      child: mainBody(),
                    ),
                    BottomNavigationBar(
                      backgroundColor: const Color(calTracker_Red),
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.track_changes),
                          label: 'Tracker',
                          backgroundColor: Color(calTracker_Red),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.add),
                          label: 'Meal',
                          backgroundColor: Color(calTracker_Orange),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: 'User Settings',
                          backgroundColor: Colors.pink,
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.info),
                          label: 'App Info',
                          backgroundColor: Colors.pink,
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: Colors.black,
                      onTap: bottomNavBarEvent,
                    )
                  ],
                )
            );
          }),
        ));
  }

  Widget mainBody() {
    switch(_selectedIndex) {
      case 0:
        return routineBody();
      case 1:
        return addCalBody();
      case 2 :
        return addUserUpdateViewBody();
      case 3:
        return addAppInfoViewBody();
      default:
        return SizedBox();
    }
  }

  Widget addUserUpdateViewBody() {
    return UserUpdateView(userModel: userModel);
  }

  Widget addCalBody() {
    return UpsertCalView(userModel: userModel);
  }

  Widget addAppInfoViewBody() {
    return AppInfoView(userModel: userModel);
  }

  Widget routineBody() {
    if (!isLoading) {
      return Column(
        children: [
          Expanded(
            flex: 4,
            child: chartContainer(),
          ),
          Expanded(
              flex: 6,
              child:routineContainer()
          ),
        ],
      );
    } else {
      return ShareSpinner();
    }

  }

  Widget routineContainer() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(calTracker_White),
        ),
        child:  Column(
          children: [
            Expanded(child: todayRoutineList())
          ],
        )
    );
  }

  Widget todayRoutineList() {
    if (routineList.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: routineList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Card(
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3))),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(calTracker_LightBlue),
                            width: 5
                          )
                        )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child:  Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                                child:  Text(
                                                  routineList[index].searchText.capitalize() + " (g)",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                )
                                            )
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                                child:  Text(
                                                  routineList[index].calories.toString() + " Cal",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                )
                                            )
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                              child: Text(
                                                "Intake: " + routineList[index].amountByGram.toString()  + "g",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                              child:   Text(
                                                "Total Cal: " + routineList[index].totalCalories.toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                        )
                                      ],
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: isLoadingDeleteRoutine ? ShareSpinner():   IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteRoutine(routineList[index]);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
              ],
            );
          }
      );
    } else {
      return Text("No Data Found Today");
    }
  }

  void deleteRoutine(RoutineModel routine) {
    context.read<MainBloc>().add(MainParam.DeleteRoutine(eventStatus: MainEvent.Event_Routine_Delete, routine: routine));
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

  Widget chartContainer() {
    var currentDatetime = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var date = formatter.format(currentDatetime);

    setIntakeAndRemainColor();

    return Container(
      padding: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: const Color(calTracker_LightBlue),
        border: Border.all(color: const Color(calTracker_LightBlue)),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),

      ),
      child:  Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            totalDailyCal.toStringAsFixed(0),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(colorParam["intakeColor"])
                            ),
                          ),
                          Text(
                            "/" +  maxDailyCalories.toStringAsFixed(0),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(calTracker_White)
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ),
                PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        // setState(() {
                        //   if (!event.isInterestedForInteractions ||
                        //       pieTouchResponse == null ||
                        //       pieTouchResponse.touchedSection == null) {
                        //     touchedIndex = -1;
                        //     return;
                        //   }
                        //   touchedIndex = pieTouchResponse
                        //       .touchedSection!.touchedSectionIndex;
                        // });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: showingSections()),
                )
              ],
            )

          ),
        ],
      ),
    );
  }

  void bottomNavBarEvent(int index) {
    context.read<MainBloc>().add(MainParam.WidgetStateInt(eventStatus: MainEvent.Event_Widget_State_Integer, stateInt: index));
  }

  VoidCallback? solidBtnOnClick(String text, String event) {
    return () {
      solidButtonEvent(event);
    };
  }

  void solidButtonEvent(String event) {
    switch (event) {
      case "ADD-CAL":
        context.read<MainBloc>().add(MainParam.NavToUser(eventStatus: MainEvent.Event_Nav_Calo, context: context, user: userModel));
        break;
      default:
        break;
    }

  }

  void getDailyRoutine() {
    var param = {
      "userId": userModel.userId,
      "dateTime": DateTime.now().toString()
    };
    context.read<MainBloc>().add(MainParam.GetRoutine(eventStatus: MainEvent.Event_Routine_Get, param: param));
  }

  void calculateDailyRoutineRation() {
    caloriesRatio = (totalDailyCal / maxDailyCalories)  * 100;
    remainingCaloriesRatio = remainingCaloriesRatio - caloriesRatio;
  }


  List<PieChartSectionData> showingSections() {

    setIntakeAndRemainColor();

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 10.0;
      final radius = isTouched ? 90.0 : 35.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(colorParam['intakeColor']),
            value: colorParam['intakeCal'],
            title: "Intake\n" + caloriesRatio.toStringAsFixed(2) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(calTracker_Black)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(calTracker_Gray),
            value: colorParam['remainCal'],
            title: "Limit\n" + remainingCaloriesRatio.toStringAsFixed(2) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(calTracker_White)),
          );
        default:
          throw Error();
      }
    });
  }
}