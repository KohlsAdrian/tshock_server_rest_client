import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tshock_server_rest/tshock_server_rest_server.dart';

class LoggedController extends GetxController {
  String _userName = '';

  String get userName => _userName;

  @override
  void onInit() async {
    super.onInit();
    TShockServerRESTServer.instance.testToken().then((result) {
      _userName = result['associateduser'];
      update();
    });
  }
}
