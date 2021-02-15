import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest_client/controllers/logged_controller.dart';
import 'package:tshock_server_rest_client/main.dart';
import 'package:tshock_server_rest_client/pages/bans_ui.dart';
import 'package:tshock_server_rest_client/pages/groups_ui.dart';
import 'package:tshock_server_rest_client/pages/players_ui.dart';
import 'package:tshock_server_rest_client/pages/server_ui.dart';
import 'package:tshock_server_rest_client/pages/users_ui.dart';
import 'package:tshock_server_rest_client/pages/world_ui.dart';

class LoggedUI extends StatelessWidget {
  Widget _button(String text, Function tap) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: tap,
        child: Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          color: Colors.indigo,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoggedController>(
      init: LoggedController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Hello ${controller.userName}'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'tshockRestExit',
          onPressed: () => Get.off(Home()),
          label: Text('Exit'),
          icon: Icon(Icons.exit_to_app),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _button('Players', () => Get.to(() => PlayersUI())),
              _button('Users', () => Get.to(() => UsersUI())),
              _button('World', () => Get.to(() => WorldUI())),
              _button('Bans', () => Get.to(() => BansUI())),
              _button('Groups', () => Get.to(() => GroupsUI())),
              _button('Server', () => Get.to(() => ServerUI())),
            ],
          ),
        ),
      ),
    );
  }
}
