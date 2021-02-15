import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest_client/controllers/world_controller.dart';

class WorldUI extends StatelessWidget {
  Widget _item(String title, String content) => ListTile(
        title: Text(title),
        subtitle: Text(content),
      );
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorldController>(
      init: WorldController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('World'),
        ),
        floatingActionButton: Wrap(
          alignment: WrapAlignment.end,
          spacing: 10.0,
          runSpacing: 20.0,
          children: [
            FloatingActionButton.extended(
              heroTag: 'worldBloodMoon',
              onPressed: controller.toggleBloodMoon,
              label: Text('Toggle BloodMoon'),
              icon: Icon(Icons.cloud),
            ),
            FloatingActionButton.extended(
              heroTag: 'worldButcher',
              onPressed: controller.butcher,
              label: Text('Butcher'),
              icon: Icon(Icons.clear),
            ),
            FloatingActionButton.extended(
              heroTag: 'worldSave',
              onPressed: controller.save,
              label: Text('Save'),
              icon: Icon(Icons.save),
            ),
            FloatingActionButton.extended(
              heroTag: 'worldAutoSave',
              onPressed: controller.setAutoSave,
              label: Text('Set Auto Save'),
              icon: Icon(Icons.save_outlined),
            ),
          ],
        ),
        body: controller.tShockWorld == null
            ? null
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _item('Name', controller.tShockWorld.name),
                    _item('Size', controller.tShockWorld.size),
                    _item(
                        'Time',
                        DateTime.fromMillisecondsSinceEpoch(
                                (controller.tShockWorld.time * 1000).toInt())
                            .toIso8601String()
                            .split('T')
                            .last
                            .split('.')
                            .first),
                    _item('Day Time?',
                        controller.tShockWorld.dayTime ? 'YES' : 'NO'),
                    _item('BloodMoon?',
                        controller.tShockWorld.bloodMoon ? 'YES' : 'NO'),
                    _item('Invasion Size',
                        controller.tShockWorld.invasionSize.toString()),
                  ],
                ),
              ),
      ),
    );
  }
}
