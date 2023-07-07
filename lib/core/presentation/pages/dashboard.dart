import 'package:flutter/material.dart';
import 'package:griot_app/core/presentation/pages/base_page.dart';
import 'package:griot_app/core/presentation/widgets/griot_app_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const BasePage(
      child: Scaffold(
        appBar: GriotAppBar(
          automaticallyImplyLeading: false,
          title: 'Dashboard',
        ),
        body: Center(),
      ),
    );
  }
}
