import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:motor_flutter_starter/MQTTClientManager.dart';
import 'package:motor_flutter_starter/components/grid.dart';
import 'package:motor_flutter_starter/pages/health_page.dart';
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
  final String subTopic_chargerloc = "chargr/loc"; // format is in row, column
  int _selectedIndex = -1;
  double _carX = 4.5;
  double _carY = 3;
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
        carX: _carX, //_chargerLocX

        carY: _carY, // row
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthPage(),
                    ),
                  );
                },
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
    int row = _selectedIndex ~/ 14;
    int col = _selectedIndex % 14;
    mqttClientManager.publishMessage(pubTopic_chargeme, '$row,$col');
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

      if (c[0].topic == subTopic_chargerloc) {
        List<String> split = pt.split(",");
        setState(() {
          _carY = double.parse(split[0]);
          _carX = double.parse(split[1]);
        });
      }
    });
  }
}
