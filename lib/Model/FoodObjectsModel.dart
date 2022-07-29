import 'package:calories_tracker/Model/FoodModel.dart';

class FoodObjectsModel {
  List<FoodModel> listFood = [];

  FoodObjectsModel(Map<String, dynamic> response) {
    List<dynamic> tmpList = response["Items"];
    List<FoodModel> itemList = [];
    for(int i = 0; i < tmpList.length; i++) {
      FoodModel model = FoodModel.map(tmpList[i]);
      itemList.add(model);
    }
    if (itemList.isNotEmpty) {
      listFood = itemList;
    }
  }

  printToString() {
    for(int i = 0; i < listFood.length; i++) {
      listFood[i].printToString();
    }
  }
}