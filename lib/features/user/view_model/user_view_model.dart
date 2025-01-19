class UserViewModel {
  static final UserViewModel instance = UserViewModel._();
  UserViewModel._();

  String getIconText({required String userName}) {
    return userName.substring(0, 1).toUpperCase();
  }
}
