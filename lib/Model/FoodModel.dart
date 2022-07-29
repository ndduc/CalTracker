class FoodModel {
  double sugar_g = -1;
  double fiber_g = -1;
  double serving_size_g = -1;
  double sodium_mg = -1;
  String name = "";
  double potassium_mg = -1;
  double fat_saturated_g = -1;
  double fat_total_g = -1;
  double calories = -1;
  double cholesterol_mg = -1;
  double protein_g = -1;
  double carbohydrates_total_g = -1;

  FoodModel.map(Map<String, dynamic> map) {
    sugar_g = map["Sugar_G"];
    fiber_g = map["Fiber_G"];
    serving_size_g = map["Serving_Size_G"];
    sodium_mg = map["Sodium_Mg"];
    name = map["Name"];
    potassium_mg = map["Potassium_Mg"];
    fat_saturated_g = map["Fat_Saturated_G"];
    fat_total_g = map["Fat_Total_G"];
    calories = map["Calories"];
    cholesterol_mg = map["Cholesterol_Mg"];
    protein_g = map["Protein_G"];
    carbohydrates_total_g = map["Carbohydrates_Total_G"];
  }

  printToString() {
    print(name);
    print(calories);
  }
}