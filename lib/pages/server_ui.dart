import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest_client/controllers/server_controller.dart';

class ServerUI extends StatelessWidget {
  Widget _item(String title, String content) => ListTile(
        title: Text(title),
        subtitle: Text(content),
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServerController>(
      init: ServerController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Server'),
        ),
        floatingActionButton: Wrap(
          spacing: 10.0,
          runSpacing: 20.0,
          alignment: WrapAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'rawcmd',
              onPressed: controller.rawcommand,
              label: Text('Raw Command'),
              icon: Icon(Icons.settings_ethernet_rounded),
            ),
            FloatingActionButton.extended(
              heroTag: 'broadcast',
              onPressed: controller.broadcast,
              label: Text('Broadcast'),
              icon: Icon(Icons.people),
            ),
            FloatingActionButton.extended(
              heroTag: 'shutdown',
              onPressed: controller.shutdown,
              label: Text('Shutdown'),
              icon: Icon(Icons.power_settings_new),
            ),
          ],
        ),
        body: controller.tShockServerStatus == null
            ? null
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _item('Server name', controller.tShockServerStatus.name),
                    _item('Server Version',
                        controller.tShockServerStatus.serverVersion),
                    _item(
                        'Port', controller.tShockServerStatus.port.toString()),
                    _item('Player Count',
                        controller.tShockServerStatus.playerCount.toString()),
                    _item('Max Players',
                        controller.tShockServerStatus.maxPlayers.toString()),
                    _item(
                        'World Name', controller.tShockServerStatus.worldName),
                    _item('Up Time', controller.tShockServerStatus.uptime),
                  ],
                ),
              ),
      ),
    );
  }
}
