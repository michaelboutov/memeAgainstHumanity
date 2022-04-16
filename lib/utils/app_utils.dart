import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../model/pure_user_model.dart';
import '../views/widgets/snackbars.dart';
import 'package:nanoid/nanoid.dart';

// Generate a v1 (time-based) identifier
String generateDatabaseId() {
  return customAlphabet(
      '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM', 6);
}

String generateRandomId() {
  return const Uuid().v1();
}

// updates the user fcm token in the remote database

String getFormattedTime(DateTime date) {
  return timeago.format(date, allowFromNow: true);
}

// This function returns list of user connection

List<String> getConnections(Map<String, ConnectionStatus> data) {
  final List<String> connections = [];
// gets all the user identifier of the users am connected with in a Map.
  // The key is the userId while the value is the ConnectionStatus
  // users am connected with has ConnectionStatus to be equal to Connected

  for (final data in data.entries)
    if (data.value == ConnectionStatus.Connected) connections.add(data.key);

  return connections.toList();
}

Future<void> launchIfCan(BuildContext context, String url) async {
  final result = await canLaunch(url);
  if (result)
    launch(url);
  else {
    final message = "Please install a browser that can open the link";
    showFailureFlash(context, message);
  }
}
