import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tshock_server_rest/tshock_server_rest_server.dart';
import 'package:tshock_server_rest_client/logged_ui.dart';

class HomeController extends GetxController {
  TextEditingController _tecAddress = TextEditingController(text: '127.0.0.1');
  TextEditingController _tecPort = TextEditingController(text: '7878');
  TextEditingController _tecToken = TextEditingController();
  bool _isHttps = false;
  bool _loading = false;

  bool get isHttps => _isHttps;
  bool get loading => _loading;

  TextEditingController get tecAddress => _tecAddress;
  TextEditingController get tecPort => _tecPort;
  TextEditingController get tecToken => _tecToken;

  @override
  void onInit() async {
    super.onInit();

    SharedPreferences.getInstance().then((prefs) {
      String address = prefs.getString('address') ?? '';
      int port = prefs.getInt('port') ?? 7878;
      String token = prefs.getString('token') ?? '';
      _isHttps = prefs.getBool('isHttps') ?? false;

      _tecAddress.text = address;
      _tecPort.text = port.toString();
      _tecToken.text = token;

      update();
    });
  }

  void toggleHttps([bool isHttps]) {
    _isHttps = isHttps ?? !_isHttps;
    update();
  }

  void login() async {
    bool authed = false;
    _loading = true;
    update();

    try {
      final ip = tecAddress.text;
      final port = int.parse(tecPort.text);
      final token = tecToken.text;
      TShockServerRESTServer.instance.init(ip, port, token, isHttps: isHttps);

      final test = await TShockServerRESTServer.instance.testToken() ?? {};
      authed = test['status'] == '200';

      if (authed) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('address', ip);
        prefs.setInt('port', port);
        prefs.setString('token', token);
        prefs.setBool('isHttps', _isHttps);

        Get.offAll(() => LoggedUI());
      }
    } catch (e) {
      print(e);
    }

    _loading = false;
    update();
  }
}
