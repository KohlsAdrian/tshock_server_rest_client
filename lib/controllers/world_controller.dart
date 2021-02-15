import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest/tshock_server_rest_world.dart';

class WorldController extends GetxController {
  TShockWorld _tShockWorld;

  Timer _timer;

  TShockWorld get tShockWorld => _tShockWorld;

  bool _bloodMoon = false;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => _getWorldInfo());
    super.onInit();
    _getWorldInfo();
  }

  void _getWorldInfo() async {
    _tShockWorld = await TShockServerRESTWorld.instance.info();
    _bloodMoon = _tShockWorld.bloodMoon;
    update();
  }

  void spawnMeteor() async {
    await TShockServerRESTWorld.instance.spawnMeteor();
    _getWorldInfo();
  }

  void toggleBloodMoon() async {
    _bloodMoon = !_bloodMoon;
    await TShockServerRESTWorld.instance.setBloodMoon(_bloodMoon);
    _getWorldInfo();
  }

  void setAutoSave() async {
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        title: Text('Auto Save'),
        actions: [
          RaisedButton(
            child: Text('Cancel'),
            onPressed: Get.back,
          ),
          FlatButton(
            child: Text('Set Auto Save ON'),
            onPressed: () async {
              await TShockServerRESTWorld.instance.setAutoSave(true);
              _getWorldInfo();
              Get.back();
            },
          ),
          FlatButton(
            child: Text('Set Auto Save OFF'),
            onPressed: () async {
              await TShockServerRESTWorld.instance.setAutoSave(false);
              _getWorldInfo();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void save() async {
    await TShockServerRESTWorld.instance.save();
    _getWorldInfo();
  }

  void butcher() async {
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        title: Text('Kill NPCs'),
        actions: [
          RaisedButton(
            child: Text('Cancel'),
            onPressed: Get.back,
          ),
          FlatButton(
            child: Text('Kill All'),
            onPressed: () async {
              await TShockServerRESTWorld.instance.butcher(killFriendly: true);
              _getWorldInfo();
              Get.back();
            },
          ),
          FlatButton(
            child: Text('Kill Only Bad NPCs'),
            onPressed: () async {
              await TShockServerRESTWorld.instance.butcher(killFriendly: false);
              _getWorldInfo();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
