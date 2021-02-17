import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tshock_server_rest_client/controllers/home_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'tshockRestLogin',
          onPressed: controller.login,
          label: Text('Login'),
          icon: Icon(Icons.login),
        ),
        appBar: AppBar(
          title: Text('TShock Server Client'),
        ),
        body: controller.loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: controller.toggleHttps,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Is the server address HTTPS ?'.toUpperCase()),
                            Checkbox(
                                value: controller.isHttps,
                                onChanged: (value) =>
                                    controller.toggleHttps(value))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.5,
                                child: TextFormField(
                                  controller: controller.tecAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Server Address',
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.3,
                                child: TextFormField(
                                  controller: controller.tecPort,
                                  decoration: InputDecoration(
                                    labelText: 'REST API port',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: controller.tecToken,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'REST API Token',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Image.asset('assets/tshock.png'),
                    Image.asset('assets/terraria.png'),
                  ],
                ),
              ),
      ),
    );
  }
}
