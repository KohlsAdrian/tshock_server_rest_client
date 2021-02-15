import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest/tshock_server_rest_bans.dart';

class BansController extends GetxController {
  List<TShockBannedUser> _users = [];

  List<TShockBannedUser> get users => _users;

  Timer _timer;

  @override
  void onInit() async {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => _getBans());
    super.onInit();
    _getBans();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _getBans() async {
    _users = await TShockServerRESTBans.instance.getAllBans();
    update();
  }
}
