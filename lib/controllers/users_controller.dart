import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest/tshock_server_rest_users.dart';

class UsersController extends GetxController {
  List<TShockUser> _users = [];
  Timer _timer;

  List<TShockUser> get users => _users;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => _getUsers());
    super.onInit();
    _getUsers();
  }

  void updateUser(TShockUser user) async {
    String userId = user.id;
    TextEditingController tecGroup = TextEditingController();
    TextEditingController tecPassword = TextEditingController();
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tecGroup,
              decoration: InputDecoration(labelText: 'Update Group'),
            ),
            TextField(
              controller: tecPassword,
              decoration: InputDecoration(
                  labelText: 'Update Password (Leave empty if not)'),
            ),
          ],
        ),
        actions: [
          RaisedButton(
            onPressed: Get.back,
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () async {
              String group;
              if (tecGroup.text.isNotEmpty) group = tecGroup.text;
              String password;
              if (tecPassword.text.isNotEmpty) password = tecPassword.text;

              await TShockServerRESTUsers.instance.updateUserById(
                userId,
                group: group,
                password: password,
              );
              Get.back();
              _getUsers();
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void deleteUser(TShockUser user) async {
    String userId = user.id;
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        title: Text('Delete?'),
        actions: [
          RaisedButton(
            onPressed: Get.back,
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () async {
              await TShockServerRESTUsers.instance.destroyUserById(userId);
              Get.back();
              _getUsers();
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
    _getUsers();
  }

  void _getUsers() async {
    _users = await TShockServerRESTUsers.instance.getAllUsers();
    update();
  }

  void createUser() async {
    TextEditingController tecName = TextEditingController();
    TextEditingController tecPassword = TextEditingController();
    TextEditingController tecGroup = TextEditingController(text: 'default');
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    await showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (text) =>
                    text.isNotEmpty ? null : 'Should not be empty',
                controller: tecName,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                validator: (text) =>
                    text.isNotEmpty ? null : 'Should not be empty',
                controller: tecPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              TextFormField(
                validator: (text) =>
                    text.isNotEmpty ? null : 'Should not be empty',
                controller: tecGroup,
                decoration: InputDecoration(
                  labelText: 'Group',
                ),
              ),
            ],
          ),
        ),
        actions: [
          RaisedButton(
            onPressed: Get.back,
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () async {
              bool valid = formKey.currentState.validate();
              if (valid) {
                String name = tecName.text;
                String password = tecPassword.text;
                String group = tecGroup.text;
                await TShockServerRESTUsers.instance
                    .createUser(name, password, group);
                Get.back();
                _getUsers();
              }
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}
