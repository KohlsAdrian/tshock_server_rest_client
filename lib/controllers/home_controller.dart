import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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

  void toggleHttps([bool isHttps]) {
    if (isHttps != null) _isHttps = isHttps;
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
    } catch (e) {
      print(e);
    }

    _loading = false;
    update();

    if (authed) Get.off(() => LoggedUI());
  }
}
