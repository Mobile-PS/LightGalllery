import 'dart:convert';



import 'package:light_gallery/preferences/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_model.dart';


class PrefRepository {
  Future<SharedPreferences> _getPref() => SharedPreferences.getInstance();
  final _const = PrefConst();

  clearPreferences() async {
    (await _getPref()).remove(_const.prefRegisterUser);
  }


  saveLoginData(LoginModel? value) async {
    (await _getPref())
        .setString(_const.prefRegisterUser, json.encode(value));
  }

  Future<LoginModel?> getLoginUserData() async {
    final data = (await _getPref()).getString(_const.prefRegisterUser);
    if (data != null && data.isNotEmpty) {
      return LoginModel.fromJson(json.decode(data));
    } else {
      return null;
    }
  }


 /* saveOfflineData(OfflineDataModel? value) async {
    (await _getPref())
        .setString(_const.prefOfflineData, json.encode(value));
  }

  Future<OfflineDataModel?> getOfflineData() async {
    final data = (await _getPref()).getString(_const.prefOfflineData);
    if (data != null && data.isNotEmpty) {
      return OfflineDataModel.fromJson(json.decode(data));
    } else {
      return null;
    }
  }

  saveUserData(User_Data_Model? value) async {
    (await _getPref())
        .setString(_const.prefUserData, json.encode(value));
  }


  Future<User_Data_Model?> getUserData() async {
    final data = (await _getPref()).getString(_const.prefUserData);
    if (data != null && data.isNotEmpty) {
      return User_Data_Model.fromJson(json.decode(data));
    } else {
      return null;
    }
  }

  saveOfflieAttendenceData(List<OfflineUserData> value) async {
    (await _getPref())
        .setString(_const.AttendencefOfflineData, json.encode(value));
  }


  Future<dynamic?> getOfflieAttendenceData() async {
    final data = (await _getPref()).getString(_const.AttendencefOfflineData);
    if (data != null && data.isNotEmpty) {
      return json.decode(data);
    } else {
      return null;
    }
  }*/

}
