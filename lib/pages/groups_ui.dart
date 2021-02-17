import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest.dart';
import 'package:tshock_server_rest/tshock_server_rest_groups.dart';
import 'package:tshock_server_rest_client/controllers/groups_controller.dart';
import 'package:tshock_server_rest_client/controllers/update_group_controller.dart';

class GroupsUI extends StatelessWidget {
  void _seePermissions(
      TShockGroup tShockGroup, GroupsController controller) async {
    String name = tShockGroup.name;
    String parent = tShockGroup.parent;
    TShockGroup mTShockGroup = await TShockServerRESTGroups.instance.read(name);

    List<String> tabs = [
      'Permissions',
      'Negated\nPermissions',
      'Total\nPermissions'
    ];

    List<List<String>> permissions = [
      mTShockGroup.permissions,
      mTShockGroup.negatedPermissions,
      mTShockGroup.totalPermissions,
    ];

    await showModalBottomSheet(
      context: Get.context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight * 3,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              heroTag: 'groupsUpdateUi',
              onPressed: () =>
                  Get.off(() => UpdateGroupPermissionsUI(mTShockGroup)),
              icon: Icon(Icons.edit),
              label: Text('Update'),
            ),
            appBar: AppBar(
              title: Text('$name - ($parent)'),
              bottom: TabBar(
                tabs: tabs
                    .map((e) => Tab(
                          child: Text(
                            e,
                            textAlign: TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: permissions
                  .map(
                    (mPermissions) => ListView.builder(
                      itemCount: mPermissions.length,
                      itemBuilder: (context, index) {
                        String permission = mPermissions[index];
                        return ListTile(title: Text(permission));
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupsController>(
      init: GroupsController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(title: Text('Groups')),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'groupsUi',
          onPressed: () => Get.to(() => UpdateGroupPermissionsUI(null)),
          icon: Icon(Icons.group_add),
          label: Text('Create Group'),
        ),
        body: controller.groups.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Text('Nothing here at the moment.'),
                ),
              )
            : ListView.builder(
                itemCount: controller.groups.length,
                itemBuilder: (context, index) {
                  TShockGroup group = controller.groups[index];
                  String name = group.name;
                  String parent = group.parent;

                  List<int> chatColor = group.chatColor
                      .split(',')
                      .map((e) => int.parse(e))
                      .toList();
                  Color color = Color.fromARGB(
                      1, chatColor[0], chatColor[1], chatColor[2]);

                  return ListTile(
                    tileColor: color,
                    title: Text('$name ($parent)'),
                    subtitle: Text('Press to see permissions'),
                    onTap: () => _seePermissions(group, controller),
                  );
                },
              ),
      ),
    );
  }
}

class UpdateGroupPermissionsUI extends StatelessWidget {
  UpdateGroupPermissionsUI(this.tShockGroup);
  final TShockGroup tShockGroup;

  @override
  Widget build(BuildContext context) {
    String name = tShockGroup?.name ?? '';
    String parent = tShockGroup?.parent ?? '';
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return GetBuilder<UpdateGroupController>(
      init: UpdateGroupController(tShockGroup),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(tShockGroup == null
              ? 'Create Group'
              : 'Update Group: $name ($parent)'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'groupsUi',
          onPressed: controller.save,
          label: Text('Save'),
          icon: Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              if (tShockGroup == null)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lime, width: 5.0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: controller.tecGroupName,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Group Name',
                      ),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.5,
                    child: Column(
                      children: [
                        Slider(
                          divisions: 255,
                          label: controller.red.toString(),
                          min: 0,
                          max: 255,
                          value: controller.red.toDouble(),
                          onChanged: (value) => controller.updateRed(value),
                        ),
                        Slider(
                          divisions: 255,
                          label: controller.green.toString(),
                          min: 0,
                          max: 255,
                          value: controller.green.toDouble(),
                          onChanged: (value) => controller.updateGreen(value),
                        ),
                        Slider(
                          divisions: 255,
                          label: controller.blue.toString(),
                          min: 0,
                          max: 255,
                          value: controller.blue.toDouble(),
                          onChanged: (value) => controller.updateBlue(value),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text('Chat color RGB'),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: 100,
                        width: width * 0.3,
                        decoration: BoxDecoration(
                          color: controller.newColor,
                          border: Border.all(color: Colors.lime, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lime, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: controller.tecParent,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Parent',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lime, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    controller: controller.tecPermissions,
                    maxLines: 50,
                    decoration: InputDecoration(
                      labelText: 'Permissions',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
