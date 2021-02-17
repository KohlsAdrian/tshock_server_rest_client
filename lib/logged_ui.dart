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
  final _items = [
    {
      'title': 'Players',
      'description': 'Kill, Kick, Ban, Mute and Unmute online players',
      'icon': Icons.person,
      'page': PlayersUI(),
    },
    {
      'title': 'Users',
      'description': 'Create user, delete, update group and password',
      'icon': Icons.person_search,
      'page': UsersUI(),
    },
    {
      'title': 'World',
      'description':
          'See detailed informations about the world and manage events.',
      'icon': Icons.filter_hdr_sharp,
      'page': WorldUI(),
    },
    {
      'title': 'Bans',
      'description':
          'See detailed information about banned users and unban users.',
      'icon': Icons.block,
      'page': BansUI(),
    },
    {
      'title': 'Groups',
      'description': 'Manage groups and edit permissions.',
      'icon': Icons.group,
      'page': GroupsUI(),
    },
    {
      'title': 'Server',
      'description':
          'See detailed information about the server. Run any commands or shutdown. it',
      'icon': Icons.storage,
      'page': ServerUI(),
    },
  ];

  Widget _itemList(Map<String, dynamic> item) {
    String title = item['title'];
    String description = item['description'];
    Widget page = item['page'];
    return InkWell(
      onTap: () => Get.to(() => page),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Icon(
              item['icon'],
              size: 40,
            ),
          ),
          Container(
            width: MediaQuery.of(Get.context).size.width * 0.8,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
          actions: [
            IconButton(
              onPressed: () => Get.offAll(() => Home()),
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: ListView.separated(
          itemCount: _items.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) => _itemList(_items[index]),
        ),
      ),
    );
  }
}
