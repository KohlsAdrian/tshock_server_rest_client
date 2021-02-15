import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/model/tshock_user.dart';
import 'package:tshock_server_rest/tshock_server_rest_players.dart';
import 'package:tshock_server_rest/tshock_server_rest_server.dart';

class PlayersController extends GetxController {
  Timer _timer;
  List<TShockUser> _users = [];

  List<TShockUser> get users => _users;

  @override
  void onInit() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => _getPlayers());
    super.onInit();
    _getPlayers();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _getPlayers() async {
    final activeUsers =
        await TShockServerRESTServer.instance.users.getActiveUsers();
    _users = await TShockServerRESTServer.instance.users.getAllUsers();

    _users.removeWhere((element) => !activeUsers.contains(element.name));
    update();
  }

  Future<void> reasonDialog(String name, Function action) async {
    TextEditingController tecReason = TextEditingController();
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        content: TextFormField(
          decoration: InputDecoration(labelText: 'Reason (Optional)'),
          controller: tecReason,
        ),
        actions: [
          RaisedButton(
            child: Text('Cancel'),
            onPressed: Get.back,
          ),
          FlatButton(
            child: Text('Done'),
            onPressed: () {
              action(tecReason.text);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void kick(String name) async {
    await reasonDialog(name, (String reason) {
      TShockServerRESTPlayers.instance.kick(name, reason: reason);
      _getPlayers();
    });
  }

  void ban(String name) async {
    await reasonDialog(name, (String reason) {
      TShockServerRESTPlayers.instance.ban(name, reason: reason);
      _getPlayers();
    });
  }

  void mute(String name) async {
    await reasonDialog(name, (String reason) {
      TShockServerRESTPlayers.instance.mute(name, reason: reason);
    });
  }

  void unmute(String name) async {
    await reasonDialog(name, (String reason) {
      TShockServerRESTPlayers.instance.unmute(name, reason: reason);
    });
  }

  void kill(String name) async {
    await TShockServerRESTPlayers.instance.kill(name);
  }
}
