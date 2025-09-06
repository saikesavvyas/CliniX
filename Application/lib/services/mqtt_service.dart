import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  static final MQTTService _instance = MQTTService._internal();
  factory MQTTService() => _instance;
  MQTTService._internal();

  final String broker = 'broker.hivemq.com';
  final int port = 1883;
  MqttServerClient? client;

  String currentSource = 'Grid';
  double currentVoltage = 220.0;
  int batteryLevel = 82;
  int backupTime = 164;
  List<double> voltageData = [220.0, 219.5, 221.0, 218.0, 222.5, 220.0];

  Future<void> connect() async {
    client = MqttServerClient(broker, 'flutter_client_${DateTime.now().millisecondsSinceEpoch}');
    client!.port = port;
    client!.keepAlivePeriod = 60;
    client!.logging(on: false);

    try {
      await client!.connect();
      print('Connected to MQTT Broker');

      client!.subscribe('clinix/power/source', MqttQos.atMostOnce);
      client!.subscribe('clinix/power/voltage', MqttQos.atMostOnce);
      client!.subscribe('clinix/power/battery', MqttQons.atMostOnce);

      client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        final String topic = c[0].topic;

        print('Received: $payload from $topic');

        if (topic == 'clinix/power/source') {
          currentSource = payload;
        } else if (topic == 'clinix/power/voltage') {
          try {
            final double voltage = double.parse(payload);
            currentVoltage = voltage;
            voltageData.add(voltage);
            if (voltageData.length > 20) voltageData.removeAt(0);
          } catch (e) {
            print('Error parsing voltage: $e');
          }
        } else if (topic == 'clinix/power/battery') {
          try {
            batteryLevel = int.parse(payload);
            backupTime = (batteryLevel * 2.2).toInt();
          } catch (e) {
            print('Error parsing battery: $e');
          }
        }
      });

    } catch (e) {
      print('Exception: $e');
    }
  }

  void disconnect() {
    client?.disconnect();
  }
}
