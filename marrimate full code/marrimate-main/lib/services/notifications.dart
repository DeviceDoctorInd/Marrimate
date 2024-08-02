import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationServices{

  static postNotification(
      {String title, String body, String partnerID, String purpose, String receiverToken}) async {
    String url = 'https://fcm.googleapis.com/fcm/send';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=AAAADmlmcOU:APA91bE4b6RB1WNLNok8-hnZB-Nl7DzCvrrBRfipLpgM5ClCkDuWvgfEy6_kIVa-L-0nALdogvbmtfLm0gzpr0ScYXRhAOoZC_dwDqDqm_bhk9UepzUjNEA90X91u6CihCJ49TkZcTRX"
    };
    var json = jsonEncode({
      "notification": {
        "body": body,
        "title": title,
        "sound": "default",
        "color": "#990000",
      },
      "priority": "high",
      "data": {
        "clickaction": "FLUTTERNOTIFICATIONCLICK",
        "purpose": purpose,
        "partnerID": partnerID,
        "status": "done"
      },
      "to": receiverToken,
    });
    var response = await http.post(
        Uri.parse(url), headers: headers, body: json);
    print("Notification sent: " + response.statusCode.toString() +", to: " + receiverToken);
    print("Notification: " + response.body);
  }

}