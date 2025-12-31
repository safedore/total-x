// --- Base Domains ---
class AppDomains {
  // static const String root = 'http://192.168.27.172:5000';
  static const String root = 'http://safedore3.pythonanywhere.com';
  static const String api = '$root/api';
}

// --- User/Profile Endpoints ---
class UserUrls {
  static const String createUser = '${AppDomains.api}/create-user';
  static const String readUsersAll = '${AppDomains.api}/read-users-all';
  static const String readUsers = '${AppDomains.api}/read-users';
  static const String readUserDetails = '${AppDomains.api}/read-user-single';
  static const String updateUser = '${AppDomains.api}/update-user';
  static const String deleteUser = '${AppDomains.api}/delete-user';

  }
