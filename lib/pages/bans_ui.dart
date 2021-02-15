import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest/tshock_server_rest_bans.dart';
import 'package:tshock_server_rest_client/controllers/bans_controller.dart';

class BansUI extends StatelessWidget {
  void _banDetails(TShockBannedUser user) async {
    TShockBannedUser bannedUser =
        await TShockServerRESTBans.instance.getBannedUserByName(user.name);

    await Get.to(() => BannedUserDetailsUI(bannedUser));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BansController>(
      init: BansController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Bans'),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            TShockBannedUser user = controller.users[index];
            String name = user.name;
            String whobanned = user.banningUser;
            return Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.red[200],
                  ),
                  child: ListTile(
                    title: Text('$name'),
                    subtitle: Text('banned by: $whobanned'),
                    onTap: () => _banDetails(user),
                  ),
                ),
                Icon(
                  Icons.arrow_right_alt_sharp,
                  size: 40,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BannedUserDetailsUI extends StatelessWidget {
  BannedUserDetailsUI(this.bannedUser);
  final TShockBannedUser bannedUser;

  Widget _item(String title, String content) {
    return ListTile(
      title: Text(title),
      subtitle: Text(content),
    );
  }

  void _unban() async {
    await TShockServerRESTBans.instance.removeBan(bannedUser.name);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banned User Details')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              _item('Name', bannedUser.name),
              _item('IP', bannedUser.ip),
              _item('Banned by', bannedUser.banningUser),
              _item('Date', bannedUser.date),
              _item('Reason', bannedUser.reason),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: FloatingActionButton.extended(
              onPressed: _unban,
              label: Text(
                'Unban',
                style: TextStyle(fontSize: 25),
              ),
              icon: Icon(
                Icons.cleaning_services_outlined,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
