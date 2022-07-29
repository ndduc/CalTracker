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

  double maxDailyCalories = 2500;
  double caloriesRatio = 0;
  double remainingCaloriesRatio = 100;

  /// Bottom Nav Index
  int _selectedIndex = 0;

  /// Chart Index
  int touchedIndex = -1;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    widget.userModel.printToString();
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
      caloriesRatio = 0;
      remainingCaloriesRatio = 100;
      totalDailyCal = 0;
      totalDailyProtein = 0;
      routineList = state.routines;
      routineList.forEach((item) {
        totalDailyCal += item.totalCalories;
        totalDailyProtein += item.totalProtein;
      });
      calculateDailyRoutineRation();
      isLoading = false;

    }
    else if (state is GetRoutineErrorState) {
      isLoading = false;

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
            appRoutineEvent(state);
            /**
             * Bloc Action Note
             * END
             * */
            return Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6)
              ),
              padding: EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Expanded(
                      child: mainBody(),
                    ),
                    BottomNavigationBar(
                      backgroundColor: Color(0xffF87474),
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                          backgroundColor: Color(0xffF87474),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.add),
                          label: 'Meal',
                          backgroundColor: Color(0xffffb562),
                        ),
                        // BottomNavigationBarItem(
                        //   icon: Icon(Icons.settings),
                        //   label: 'Settings',
                        //   backgroundColor: Colors.pink,
                        // ),
                        // BottomNavigationBarItem(
                        //   icon: Icon(Icons.settings),
                        //   label: 'Settings',
                        //   backgroundColor: Colors.pink,
                        // ),
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
        return RoutineBody();
      case 1:
        return AddCalBody();
      default:
        return SizedBox();
    }
  }

  Widget AddCalBody() {
    return UpsertCalView(userModel: userModel);
  }

  Widget RoutineBody() {
    if (!isLoading) {
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: ChartContainer(),
          ),
          Expanded(
              flex: 7,
              child:RoutineContainer()
          ),
        ],
      );
    } else {
      return ShareSpinner();
    }

  }

  Widget RoutineContainer() {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: Color(0xff3AB0FF),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          border: Border.all(color: Color(0xff3AB0FF)),
        ),
        child:  Column(
          children: [
            Expanded(child: TodayRoutineList())
          ],
        )
    );
  }

  Widget TodayRoutineList() {
    if (routineList.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: routineList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  color: Color(0xfff6f6f6),
                  child: Row(
                    children: [
                      Expanded(
                          child:  Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
                                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                          },
                        ),
                      )


                    ],
                  )
                ),

              ],
            )
            ;
          }
      );
    } else {
      return Text("No Data Found Today");
    }
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

  Widget ChartContainer() {
    var currentDatetime = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var date = formatter.format(currentDatetime);

    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xfff6f6f6),
            ),
            // aspectRatio: 1,
            child: PieChart(
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
                  sectionsSpace: 3,
                  centerSpaceRadius: 20,
                  sections: showingSections()),
            ),
          ),
        ),
        Expanded(
            flex: 5,
            child: Container(
                decoration: BoxDecoration(
                  color: Color(0xfff6f6f6),
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                            date,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Daily Calories",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      )
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Text(
                          maxDailyCalories.toStringAsFixed(0),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Total Calories Intake",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        )
                    ),
                    Container(
                        child: Text(
                          totalDailyCal.toStringAsFixed(2),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        )
                    ),
                  ],
                )
            )
        )
        ,
      ],
    )
    ;
  }

  Widget GetPieChart() {
    return PieChart(
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
          centerSpaceRadius: 30,
          sections: showingSections()),
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

    int intakeColor = 0xfff8b250;

    if (caloriesRatio <= 25) {
      intakeColor = 0xfff8b250;
    } else if (caloriesRatio > 25 && caloriesRatio <= 75) {
      intakeColor = 0xff80ff80;
    } else {
      intakeColor = 0xffff0000;
    }

    var intakeCal = caloriesRatio;
    var remainCal = remainingCaloriesRatio;
    if (caloriesRatio > 100) {
      intakeCal = 100;
    }

    if (remainingCaloriesRatio < 0) {
      remainCal = 0;
    }

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 10.0;
      final radius = isTouched ? 90.0 : 60.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(intakeColor),
            value: intakeCal,
            title: "Intake\n" + caloriesRatio.toStringAsFixed(2) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff808080),
            value: remainCal,
            title: "Limit\n" + remainingCaloriesRatio.toStringAsFixed(2) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}