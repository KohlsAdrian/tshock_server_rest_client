import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest_client/controllers/users_controller.dart';

class UsersUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersController>(
      init: UsersController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: controller.createUser,
          label: Text('Create User'),
          icon: Row(
            children: [
              Icon(Icons.add),
              Icon(Icons.person),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            TShockUser user = controller.users[index];
            String id = user.id;
            String name = user.name;
            String group = user.group;
            return Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(Get.context).size.width * 0.8,
                      child: ListTile(
                        title: Text('$id - $name'),
                        subtitle: Text('group: $group'),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit, size: 40),
                            onPressed: () => controller.updateUser(user)),
                        IconButton(
                            icon: Icon(Icons.delete, size: 40),
                            onPressed: () => controller.deleteUser(user)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
