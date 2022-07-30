class UserModel {
  late String userName;
  late String password;
  String userId = "";
  late double dailyCaloriesLimit;
  bool isActive = false;
  bool loginPersistence = false;
  DateTime created = DateTime.now();
  DateTime updated = DateTime.now();

  UserModel() {}

  UserModel.map(Map<String, dynamic> map) {
    userName = map["UserName"];
    password = map["Password"];
    userId = map["UserId"];
    dailyCaloriesLimit = map["DailyCaloriesLimit"];
    isActive = map["IsActive"];
    loginPersistence = map["LoginPersistence"];
    created = DateTime.parse(map["Created"]);
    updated = DateTime.parse(map["Updated"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "password": password,
      "userId": userId,
      "dailyCaloriesLimit": dailyCaloriesLimit.toString(),
      "isActive": isActive.toString(),
      "loginPersistence": loginPersistence.toString(),
      "created": created.toString(),
      "updated": updated.toString(),
    };
  }


  printToString() {
    print(userName);
    print(password);
    print(userId);
    print(isActive);
    print(loginPersistence);
    print(created);
    print(updated);
  }
}