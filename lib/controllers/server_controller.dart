import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest/tshock_server_rest_server.dart';

class ServerController extends GetxController {
  TShockServerStatus _tShockServerStatus;

  Timer _timer;

  TShockServerStatus get tShockServerStatus => _tShockServerStatus;

  @override
  void onInit() async {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => _getServer());
    super.onInit();
    _getServer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _getServer() async {
    _tShockServerStatus = await TShockServerRESTServer.instance.status();
    update();
  }

  void broadcast() async {
    TextEditingController tecBroadcast = TextEditingController();
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: tecBroadcast,
          decoration: InputDecoration(labelText: 'Broadcast Message'),
        ),
        actions: [
          RaisedButton(
            onPressed: Get.back,
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () async {
              final message = tecBroadcast.text;
              await TShockServerRESTServer.instance.broadcast(message);
              Get.back();
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void rawcommand() async {
    TextEditingController tecCmd = TextEditingController();
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: tecCmd,
          decoration: InputDecoration(labelText: 'Raw Command'),
        ),
        actions: [
          RaisedButton(
            onPressed: Get.back,
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () async {
              final cmd = tecCmd.text;
              await TShockServerRESTServer.instance.rawCommand(cmd);
              Get.back();
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void shutdown() async {
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        title: Text('Shutdown?'),
        actions: [
          RaisedButton(
            onPressed: Get.back,
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () async {
              try {
                TShockServerRESTServer.instance.shutdown(true);
              } catch (e) {
                print(e);
              }
              Get.back();
              Get.back();
            },
            child: Text('Shutdown'),
          ),
        ],
      ),
    );
  }
}
