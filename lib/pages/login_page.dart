import 'package:flutter/material.dart';
import 'package:login_sdk/dao/login_dao.dart';
import 'package:login_sdk/util/navigator_util.dart';
import 'package:login_sdk/util/padding_extension.dart';
import 'package:login_sdk/widget/login_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/string_util.dart';
import '../widget/input_widget.dart';

///登录页
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginEnable = false;
  String? userName;
  String? password;

  get _background {
    return [
      Positioned.fill(
          child: Image.network(
        'https://o.devio.org/images/bg_cover/robot.webp',
        fit: BoxFit.cover,
      )),
      Positioned.fill(
          child: Container(
        decoration: const BoxDecoration(color: Colors.black54),
      ))
    ];
  }

  get _content {
    return Positioned.fill(
      left: 25,
      right: 25,
      child: ListView(
        children: [
          100.paddingHeight,
          const Text(
            'ChatGPT',
            style: TextStyle(fontSize: 26, color: Colors.white),
          ),
          40.paddingHeight,
          InputWidget(
            hint: '请输入账号',
            onChanged: (text) {
              userName = text;
              _checkInput();
            },
          ),
          40.paddingHeight,
          InputWidget(
            hint: '请输入密码',
            obscureText: true,
            onChanged: (text) {
              password = text;
              _checkInput();
            },
          ),
          45.paddingHeight,
          LoginButton(
            title: '登录',
            enable: loginEnable,
            //有参数需要用箭头函数
            onPressed: () => _login(context),
          ),
          15.paddingHeight,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: _jumpRegistration,
              child: const Text(
                '注册账号',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //防止键盘弹出时页面变形
      body: Stack(
        children: [..._background, _content],
      ),
    );
  }

  _jumpRegistration() async {
    //跳转到注册页面
    Uri uri = Uri.parse(
        'https://api.devio.org/uapi/swagger-ui.html#/Account/registrationUsingPOST');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('打开浏览器失败');
    }
  }

  void _checkInput() {
    //检查输入框是否为空
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
      debugPrint('loginEnable: $loginEnable');
    });
  }

  _login(BuildContext context) async {
    try {
      await LoginDao.login(userName: userName!, password: password!);
      debugPrint('登录成功');
      if (context.mounted) {
        NavigatorUtil.goToHome(context);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
