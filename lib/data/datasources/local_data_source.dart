// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../models/user_model.dart';
//
// abstract class AuthLocalDataSource {
//   Future<UserModel?> getCachedUser();
//   Future<void> cacheUser(UserModel userToCache);
// }
//
// class AuthLocalDataSourceImpl implements AuthLocalDataSource {
//   final SharedPreferences sharedPreferences;
//
//   AuthLocalDataSourceImpl(this.sharedPreferences);
//
//   @override
//   Future<UserModel?> getCachedUser() async {
//     final jsonString = sharedPreferences.getString('cached_user');
//     if (jsonString != null) {
//       return UserModel.fromJson(Map<String, dynamic>.from(json.decode(jsonString)));
//     }
//     return null;
//   }
//
//   @override
//   Future<void> cacheUser(UserModel userToCache) async {
//     await sharedPreferences.setString('cached_user', json.encode(userToCache.toJson()));
//   }
// }
//
