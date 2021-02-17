import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest/tshock_server_rest_groups.dart';

class UpdateGroupController extends GetxController {
  UpdateGroupController(TShockGroup tShockGroup) {
    _groupName = tShockGroup?.name ?? '';
    _parent = tShockGroup?.parent ?? '';
    _permissions = List.of(tShockGroup?.permissions ?? []);

    List<int> colors = tShockGroup == null
        ? [255, 255, 255]
        : tShockGroup.chatColor.split(',').map((e) => int.parse(e)).toList();

    _red = colors[0];
    _green = colors[1];
    _blue = colors[2];

    if (tShockGroup == null) {
      _isCreate = true;
    }
  }

  bool _isCreate = false;

  String _groupName;
  String _parent;

  TextEditingController _tecGroupName = TextEditingController();
  TextEditingController _tecPermissions = TextEditingController();
  TextEditingController _tecParent = TextEditingController();

  List<String> _permissions = [];

  int _red = 0;
  int _green = 0;
  int _blue = 0;

  List<String> get permissions => _permissions;

  TextEditingController get tecGroupName => _tecGroupName;
  TextEditingController get tecPermissions => _tecPermissions;
  TextEditingController get tecParent => _tecParent;

  int get red => _red;
  int get green => _green;
  int get blue => _blue;

  Color get newColor => Color.fromARGB(255, _red, _green, _blue);

  @override
  void onInit() {
    _tecParent.text = _parent;

    String mPermissions = '';
    _permissions.forEach((p) {
      mPermissions += p;
      if (_permissions.last != p) mPermissions += ', ';
    });
    _tecPermissions.text = mPermissions;
    super.onInit();
  }

  void save() async {
    List<String> newPermissions =
        tecPermissions.text.replaceAll(' ', '').replaceAll('\n', '').split(',');
    String newParent = tecParent.text;

    if (_isCreate)
      await TShockServerRESTGroups.instance.create(
        _tecGroupName.text,
        newParent,
        newPermissions,
        _red,
        _green,
        _blue,
      );
    await TShockServerRESTGroups.instance.update(
      _groupName,
      parent: newParent,
      permissions: newPermissions,
      chatRgbRED: _red,
      chatRgbGREEN: _green,
      chatRgbBLUE: _blue,
    );
    Get.back();
  }

  void updateRed(double value) {
    _red = value.toInt();
    update();
  }

  void updateGreen(double value) {
    _green = value.toInt();
    update();
  }

  void updateBlue(double value) {
    _blue = value.toInt();
    update();
  }
}
