import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest/tshock_server_rest_groups.dart';

class GroupsController extends GetxController {
  List<TShockGroup> _groups = [];

  Timer _timer;

  List<TShockGroup> get groups => _groups;

  @override
  void onInit() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => _getGroups());
    super.onInit();
    _getGroups();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _getGroups() async {
    _groups = await TShockServerRESTGroups.instance.list();
    update();
  }
}
