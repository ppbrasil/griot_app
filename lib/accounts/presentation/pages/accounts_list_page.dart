import 'package:flutter/material.dart';
import 'package:griot_app/core/presentation/widgets/griot_bottom_navigation_bar.dart';

class AccountsListPage extends StatefulWidget {
  const AccountsListPage({super.key});

  @override
  State<AccountsListPage> createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: const Center(
            child: Expanded(
              flex: 1,
              child: Text(
                'Você está logado',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const GriotBottomNavigationBar(),
    );
  }
}
