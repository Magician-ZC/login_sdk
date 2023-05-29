import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hi_cache/flutter_hi_cache.dart';
import 'package:http/http.dart' as http;
import 'package:login_sdk/util/header_util.dart';
import 'package:login_sdk/util/navigator_util.dart';

///登录接口
class LoginDao {
  static const kUserInfo = 'user_info';
  static login({required String userName, required String password}) async {
    Map<String, String> paramsMap = {};
    paramsMap['userName'] = userName;
    paramsMap['password'] = password;
    var uri = Uri.https('api.devio.org', 'uapi/user/login', paramsMap);
    final response = await http.post(uri, headers: hiHeaders());
    Utf8Decoder utf8decoder = const Utf8Decoder(); //修复中文乱码
    String bodyString = utf8decoder.convert(response.bodyBytes);
    debugPrint(bodyString);
    if (response.statusCode == 200) {
      var result = json.decode(bodyString);
      if (result['code'] == 0 && result['data'] != null) {
        Map<String, dynamic> extra = result['extra'];
        //保存登录信息
        _saveUserInfo(
            boardingPass: result['data'],
            userName: extra['userName'],
            avatar: extra['avatar'],
            imoocId: extra['imoocId']);
      } else {
        throw Exception(bodyString);
      }
    } else {
      throw Exception(bodyString);
    }
  }

  static void _saveUserInfo(
      {required boardingPass,
      required userName,
      required avatar,
      required imoocId}) {
    var map = {
      'boardingPass': boardingPass,
      'accountHash': userName.hashCode,
      'userName': userName,
      'avatar': avatar,
      'imoocId': imoocId
    };
  }

  ///获取当前登录用户信息
  static Map<String, dynamic>? getUserInfo() {
    var result = HiCache.getInstance().get(kUserInfo);
    if (result != null) {
      return jsonDecode(result);
    }
    return null;
  }

  ///获取登录token
  static String? getBoardingPass() {
    var result = HiCache.getInstance().get(kUserInfo);
    if (result != null) {
      var map = jsonDecode(result);
      return map['boardingPass'];
    }
    return null;
  }

  ///获取用于创建多账号数据的账号标识
  static String? getAccountHash() {
    var result = HiCache.getInstance().get(kUserInfo);
    if (result != null) {
      var map = jsonDecode(result);
      return map['accountHash'].toString();
    }
    return null;
  }

  ///登出
  static void logOut() {
    //清空登录信息
    HiCache.getInstance().remove(kUserInfo);
    NavigatorUtil.goToLogin();
  }
}
