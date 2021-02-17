import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest_client/controllers/players_controller.dart';

class PlayersUI extends StatelessWidget {
  Widget buttonAction(String title, IconData icon, Function action) => InkWell(
        onTap: action,
        child: Container(
          width: MediaQuery.of(Get.context).size.width / 5,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.amber,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              Text(title),
            ],
          ),
        ),
      );

  Widget _actions(PlayersController controller, TShockUser user) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonAction(
                  'Mute', Icons.volume_off, () => controller.mute(user.name)),
              buttonAction('Unmute', Icons.volume_up,
                  () => controller.unmute(user.name)),
            ],
          ),
          Divider(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonAction(
                  'Kill', Icons.mood_bad, () => controller.kill(user.name)),
              buttonAction(
                  'Kick', Icons.do_not_step, () => controller.kick(user.name)),
            ],
          ),
          Divider(height: 10),
          buttonAction('Ban', Icons.close, () => controller.ban(user.name)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayersController>(
      init: PlayersController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Players'),
        ),
        body: controller.users.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Text('Nothing here at the moment.'),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  TShockUser user = controller.users[index];
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.teal[300],
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          ListTile(
                            title: Text(user.id + ' - ' + user.name),
                            subtitle: Text('group: ' + user.group),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('${user.name} - Actions'),
                                  content: _actions(controller, user),
                                ),
                              );
                            },
                          ),
                          Icon(Icons.arrow_right_alt),
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
