import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motor_flutter_starter/MQTTClientManager.dart';
import 'package:motor_flutter_starter/components/grid.dart';
import 'package:mqtt_client/mqtt_client.dart';
// import 'package:pairx'

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MQTTClientManager mqttClientManager = MQTTClientManager();
  final String pubTopic_chargeme = "chargr/chargeme";
  final String subTopic_chargerloc = "chargr/charger-loc";   // format is in row, column
  int _selectedIndex = -1;
  // int _chargerLocX = -1;
  // int _chargerLocY = -1;
  @override
  void initState() {
    setupMqttClient();
    setupUpdatesListener();
    super.initState();
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = _selectedIndex == -1 ? Colors.grey : Colors.white;
    final backgroundColor = _selectedIndex == -1
        ? const Color(0xffd7d8d9)
        : const Color(0xffA155DD);

    return Scaffold(
      body: Grid(
        carX: _getLocX(), //_chargerLocX
        
        carY: _getLocY(),  // row
        onUpdateIndex: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(MdiIcons.heartCircle, color: Colors.grey),
                      Text('My health', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(MdiIcons.account, color: Colors.grey),
                      Text('Profile', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _requestCharge,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        child: const Icon(MdiIcons.mapMarkerDown),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _requestCharge() {
    mqttClientManager.publishMessage(pubTopic_chargeme, 'Charge has been requested!');
  }
  String _getLoc() {
    String locStr = "";
    // wildcard?
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
                final recMess = c![0].payload as MqttPublishMessage;
                locStr = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);  
              });
    return locStr;
  }
  int _getLocX(){
    String locStr = _getLoc();
    return  int.parse(locStr.split(",")[0]);
  }
  int _getLocY(){
    String locStr = _getLoc();
    return  int.parse(locStr.split(",")[Y]);
  }

  // MQTT stuff
  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(pubTopic_chargeme);
    mqttClientManager.subscribe(subTopic_chargerloc);
  }

  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  }
}
