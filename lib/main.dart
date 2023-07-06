import 'package:flutter/material.dart';
import 'package:griot_app/griot_app.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const GriotApp());
}
