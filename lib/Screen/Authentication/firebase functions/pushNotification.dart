import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  static final _firebasemessaging = FirebaseMessaging.instance;

  static Future initialise() async {
    await _firebasemessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final token = await _firebasemessaging.getToken();
    print('Token: $token');
  }
}
