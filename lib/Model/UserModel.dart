class UserModel {
  late String userName;
  late String password;
  late String userId;
  late bool isActive;
  late bool loginPersistence;
  late DateTime created;
  late DateTime updated;

  UserModel.map(Map<String, dynamic> map) {
    userName = map["UserName"];
    password = map["Password"];
    userId = map["UserId"];
    isActive = map["IsActive"];
    loginPersistence = map["LoginPersistence"];
    created = DateTime.parse(map["Created"]);
    updated = DateTime.parse(map["Updated"]);
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