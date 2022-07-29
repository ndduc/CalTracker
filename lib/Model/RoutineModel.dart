class RoutineModel {
  late String userId;
  late String searchText;
  late DateTime searchDate;
  late double amountByGram;
  late double calories;
  double totalCalories = -1;
  bool isCustom = false;
  double sugar_G = -1;
  double fiber_G = -1;
  double serving_Size_G = -1;
  double sodium_Mg = -1;
  double potassium_Mg = -1;
  double fat_Saturated_G = -1;
  double fat_Total_G = -1;
  double cholesterol_Mg = -1;
  double protein_G = -1;
  double carbohydrates_Total_G = -1;

  /// All this shit will be calculated in backend
  double totalSugar = -1;
  double totalFiber = -1;
  double totalSodium = -1;
  double totalPotassium = -1;
  double totalFatSaturated  = -1;
  double totalFat = -1;
  double totalCholesterol = -1;
  double totalProtein = -1;
  double totalCarbonhydrate = -1;

  RoutineModel.map(Map<String, dynamic> map) {
    userId = map["UserId"].toString();
    searchText = map["SearchText"].toString();
    searchDate = DateTime.parse(map["SearchDate"]);
    amountByGram = map["AmountByGram"];
    calories = map["Calories"];
    totalCalories = map["TotalCalories"];
    isCustom = map["IsCustom"];
    sugar_G = map["Sugar_G"];
    fiber_G = map["Fiber_G"];
    serving_Size_G = map["Serving_Size_G"];
    sodium_Mg = map["Sodium_Mg"];
    potassium_Mg = map["Potassium_Mg"];
    fat_Saturated_G = map["Fat_Saturated_G"];
    fat_Total_G = map["Fat_Total_G"];
    cholesterol_Mg = map["Cholesterol_Mg"];
    protein_G = map["Protein_G"];
    carbohydrates_Total_G = map["Carbohydrates_Total_G"];

    totalSugar = map["TotalSugar"];
    totalFiber = map["TotalFiber"];
    totalSodium = map["TotalSodium"];
    totalPotassium = map["TotalPotassium"];
    totalFatSaturated = map["TotalFatSaturated"];
    totalFat = map["TotalFat"];
    totalCholesterol = map["TotalCholesterol"];
    totalProtein = map["TotalProtein"];
    totalCarbonhydrate == map["TotalCarbonhydrate"];
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "searchText": searchText,
      "searchDate": searchDate.toString(),
      "amountByGram": amountByGram.toString(),
      "calories": calories.toString(),
      "totalCalories": totalCalories.toString(),
      "isCustom": isCustom.toString(),
      "sugar_g": sugar_G.toString(),
      "fiber_g": fiber_G.toString(),
      "serving_size_g": serving_Size_G.toString(),
      "sodium_mg": sodium_Mg.toString(),
      "potassium_Mg": potassium_Mg.toString(),
      "fat_saturated_g": fat_Saturated_G.toString(),
      "fat_total_g": fat_Total_G.toString(),
      "cholesterol_mg": cholesterol_Mg.toString(),
      "protein_g": protein_G.toString(),
      "carbohydrates_total_g": carbohydrates_Total_G.toString(),
    };
  }

  RoutineModel(String userId, String searchText, DateTime searchDate, double amountByGram,
      double calories, double totalCal, bool isCustom
      ) {
    this.userId = userId;
    this.searchText = searchText;
    this.searchDate = searchDate;
    this.amountByGram = amountByGram;
    this.calories = calories;
    this.totalCalories = totalCal;
    this.isCustom = isCustom;
  }
}