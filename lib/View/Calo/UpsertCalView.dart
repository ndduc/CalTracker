import 'package:calories_tracker/Bloc/MainBloc/MainBloc.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainEvent.dart';
import 'package:calories_tracker/Bloc/MainBloc/MainState.dart';
import 'package:calories_tracker/Component/ListTextField.dart';
import 'package:calories_tracker/Component/Spinner.dart';
import 'package:calories_tracker/Constant_Value/AppColor.dart';
import 'package:calories_tracker/Helper/StringHelper.dart';
import 'package:calories_tracker/Model/FoodObjectsModel.dart';
import 'package:calories_tracker/Model/RoutineModel.dart';
import 'package:calories_tracker/Model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpsertCalView extends StatefulWidget {
  UserModel userModel;

  UpsertCalView({Key? key, required this.userModel}) : super(key: key);
  @override
  _View createState() => _View();
}

class _View extends State<UpsertCalView> {
  late UserModel userModel;
  late FoodObjectsModel foodObjects;
  bool isFoodFound = false;
  bool isCustom = false;
  bool isInTakeReadOnly = false;
  bool isLoadingGetRoutine = false;
  bool isLoadingAddRoutine = false;
  TextEditingController eTSearchQuery = TextEditingController();
  TextEditingController eTIntake = TextEditingController();
  TextEditingController eTTotalCal = TextEditingController();
  TextEditingController eTCustomName = TextEditingController();
  TextEditingController eTEstCal = TextEditingController();

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
    // Executing Generic State
    if (state is GenericInitialState) {
    } else if (state is GenericLoadingState) {
    } else if (state is GenericLoadedState) {
      isCustom = state.genericBool as bool;
    }else if (state is GenericErrorState) {
    }
  }

  void appFoodEvent(MainState state) {
    // Executing Generic State
    if (state is GetFoodInitState) {
      isLoadingGetRoutine = false;
      isFoodFound = false;
    } else if (state is GetFoodLoadingState) {
      isLoadingGetRoutine = true;
      isFoodFound = false;
    } else if (state is GetFoodLoadedState) {
      foodObjects = state.foods;
      if (foodObjects.listFood.isNotEmpty) {
        isFoodFound = true;
      } else {
        isFoodFound = false;
      }
      isLoadingGetRoutine = false;
    } else if (state is GetFoodErrorState) {
      isFoodFound = false;
      isLoadingGetRoutine = false;
    }
  }

  void appRoutineEvent(MainState state) {
    if (state is AddRoutineInitState) {
      isLoadingAddRoutine = false;
    } else if (state is AddRoutineLoadingState) {
      isLoadingAddRoutine = true;
    } else if (state is AddRoutineLoadedState) {
      if (state.isSucessful) {

      } else {

      }
      isLoadingAddRoutine = false;
    }else if (state is AddRoutineErrorState) {
      isLoadingAddRoutine = false;
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
            appFoodEvent(state);
            appRoutineEvent(state);
            /**
             * Bloc Action Note
             * END
             * */
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color(calTracker_White)
              ),
                child: mainBody());
          }),
        ));
  }

  void determineIntakeReadonly() {
    if (isFoodFound && !isCustom) {
      isInTakeReadOnly = false;
    } else if (!isFoodFound && !isCustom) {
      isInTakeReadOnly = true;
    } else {
      isInTakeReadOnly = true;
    }
  }
  Widget mainBody() {
    determineIntakeReadonly();
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 45),
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(calTracker_White)
        ),
        child:  Column(
          children: [
            /// This section allow use to switch between API and custom interface
            // Row(
            //   children: [
            //     Expanded(
            //         flex: 2,
            //         child:  InkWell(
            //           onTap: () {
            //             isCustom = false;
            //             context.read<MainBloc>().add(MainParam.WidgetStateBool(eventStatus: MainEvent.Event_Widget_State_Bool, stateBool: isCustom));
            //           },
            //           child: Container(
            //             child: Text("API")
            //           )
            //         )
            //     ),
            //     Expanded(
            //         flex: 2,
            //         child:  InkWell(
            //             onTap: () {
            //               isCustom = true;
            //               context.read<MainBloc>().add(MainParam.WidgetStateBool(eventStatus: MainEvent.Event_Widget_State_Bool, stateBool: isCustom));
            //             },
            //             child: Container(
            //                 child: Text("CUSTOM")
            //             )
            //         )
            //     ),
            //     Expanded(
            //         flex: 6,
            //         child: SizedBox()
            //     )
            //   ],
            // ),
            /// State of this need to be fixed
            calInputCard(),
            showNutritionFact(),
          ],
        )

      ),
    );
  }

  Widget calInputCard() {
    return Card(
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
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Enter any food name to get the estimate calories per gram: ")
                    )
                  ],
                ),
              ),
              ApiOrCustom(),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter your daily calories (g): ")
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TotalCaloriesContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TotalCaloriesContainer() {
    bool willShowButton = false;
    if (isFoodFound && !isCustom) {
      willShowButton = true;
    } else {
      willShowButton = false;
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Custom_ListTile_TextField(
            read: isInTakeReadOnly,
            controller: eTIntake,
            labelText: "Intake By Gram",
            isMask: false,
            isNumber:true,
            mask: false,
            onChange: (value) {
              CalculateCalWithIntake(value);
            },
          ),
        ),
        Expanded(
            flex: 5,
            child: Custom_ListTile_TextField(
                read: true,
                controller: eTTotalCal,
                labelText: "Total Calories",
                isMask: false,
                isNumber:true,
                mask: false
            )
        ),
        !willShowButton ? SizedBox() :
        Expanded(
          flex: 1,
          child: isLoadingAddRoutine ? ShareSpinner() : IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addCaloriesEvent();
            },
          ),
        )
      ],
    );
  }

  void CalculateCalWithIntake(value) {
    double intake = double.parse(value);
    double foodCal = 0;
    if (!isCustom && isFoodFound) {
      foodCal = foodObjects.listFood[0].calories;
    } else {
      foodCal = double.parse(eTEstCal.text);
    }

    double totalCal = intake * foodCal;
    eTTotalCal.text = totalCal.toString();
  }

  Widget ApiOrCustom() {
    if (!isCustom) {
      return Row(
        children: [
          Expanded(
              flex: 9,
              child: Custom_ListTile_TextField(
                  read: false,
                  controller: eTSearchQuery,
                  labelText: "Search Calories",
                  hintText: "Enter text to search for approx. cal",
                  isMask: false,
                  isNumber:false,
                  mask: false
              )
          ),
          Expanded(
            flex: 1,
            child:
            isLoadingGetRoutine ? ShareSpinner() :
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Map<String, dynamic> param = {
                  "query": eTSearchQuery.text
                };
                context.read<MainBloc>().add(MainParam.GetFood(eventStatus: MainEvent.Event_NinjaFood_Get, param:param));

              },
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Custom_ListTile_TextField(
              read: false,
              controller: eTCustomName,
              labelText: "Item Name",
              isMask: false,
              isNumber:false,
              mask: false
          ),
          Custom_ListTile_TextField(
              read: false,
              controller: eTEstCal,
              labelText: "Estimate Calories By Gram",
              isMask: false,
              isNumber:true,
              mask: false
          ),
        ],
      );
    }

  }
  Widget showNutritionFact() {
    if (isLoadingGetRoutine) {
      return ShareSpinner();
    }

    if (isFoodFound && !isCustom) {
        return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: foodObjects.listFood.isNotEmpty ? 1 :  0,
            itemBuilder: (context, index) {
              return Container(
                // padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  // height: MediaQuery.of(context).size.height * 0.25,
                  child: Card(
                    child: Column(
                      children: [
                        const Text(
                          "Nutrition Fact",
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                foodObjects.listFood[index].name.toString().capitalize(),
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        nutritionFactItemContainer("Calories (g):", foodObjects.listFood[index].calories.toString(), 17),
                        nutritionFactItemContainer("Sugar (g):", foodObjects.listFood[index].sugar_g.toString(), 17),
                        nutritionFactItemContainer("Fiber (g):", foodObjects.listFood[index].fiber_g.toString(), 17),
                        // nutritionFactItemContainer("Serving (g):", foodObjects.listFood[index].serving_size_g.toString(), 17),
                        nutritionFactItemContainer("Sodium (mg):", foodObjects.listFood[index].sodium_mg.toString(), 17),
                        nutritionFactItemContainer("Fat Saturated (g):", foodObjects.listFood[index].fat_saturated_g.toString(), 17),
                        nutritionFactItemContainer("Fat Total (g):", foodObjects.listFood[index].fat_total_g.toString(), 17),
                        nutritionFactItemContainer("Cholesterol (mg):", foodObjects.listFood[index].cholesterol_mg.toString(), 17),
                        nutritionFactItemContainer("Protein (g):", foodObjects.listFood[index].protein_g.toString(), 17),
                        nutritionFactItemContainer("Carbohydrates (g):", foodObjects.listFood[index].carbohydrates_total_g.toString(), 17)
                      ],
                    ),
                  )
              )
              ;
            }
        );
    } else {
      return SizedBox();
    }
  }

  Widget nutritionFactItemContainer(String factName, String factValue, double? fSize) {
    return Container(
      margin: EdgeInsets.only(left: 15, bottom: 5),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                    child: Container(
                      child: Text(
                        factName,
                        style: TextStyle(
                            fontSize: fSize
                        ),
                      ),
                    )
                ),
                Expanded(
                  flex: 3,
                    child: Container(
                      child: Text(
                        factValue,
                        style: TextStyle(
                            fontSize: fSize
                        ),
                      ),
                    )
                ),
              ],
            ),
          )
        ],
      ),
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

  VoidCallback? solidBtnOnClick(String text, String event) {
    return () {
      solidButtonEvent(event);
    };
  }

  void addCaloriesEvent() {
    var searchText = "";
    double cal = -1;
    if (isFoodFound && !isCustom) {
      searchText = eTSearchQuery.text;
      cal = foodObjects.listFood[0].calories;
    } else {
      searchText = eTCustomName.text;
      cal = double.parse(eTEstCal.text);
    }
    double totalCal = double.parse(eTTotalCal.text);

    RoutineModel routine =  RoutineModel(userModel.userId, searchText, DateTime.now(), double.parse(eTIntake.text), cal, totalCal, isCustom);

    if (isFoodFound && !isCustom) {
      routine.sugar_G = foodObjects.listFood[0].sugar_g;
      routine.fiber_G = foodObjects.listFood[0].fiber_g;
      routine.serving_Size_G = foodObjects.listFood[0].serving_size_g;
      routine.sodium_Mg = foodObjects.listFood[0].sodium_mg;
      routine.potassium_Mg = foodObjects.listFood[0].potassium_mg;
      routine.fat_Saturated_G = foodObjects.listFood[0].fat_saturated_g;
      routine.fat_Total_G = foodObjects.listFood[0].fat_total_g;
      routine.cholesterol_Mg = foodObjects.listFood[0].cholesterol_mg;
      routine.protein_G = foodObjects.listFood[0].protein_g;
      routine.carbohydrates_Total_G = foodObjects.listFood[0].carbohydrates_total_g;
    }

    context.read<MainBloc>().add(MainParam.AddRoutine(eventStatus: MainEvent.Event_Routine_Add, routine: routine));

  }
  void solidButtonEvent(String event) {
    switch (event) {
      case "ADD-CALORIES":
        addCaloriesEvent();
        break;
      case "BACK-TO-USER":
        context.read<MainBloc>().add(MainParam.NavToUser(eventStatus: MainEvent.Event_Nav_User, context: context, user: userModel));
        break;
      default:
        break;
    }

  }

}