import 'package:flutter/material.dart';

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
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
                backgroundColor: Color.fromRGBO(81, 172, 135, 1),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: '',
                backgroundColor: Color.fromRGBO(81, 172, 135, 1),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: '',
                backgroundColor: Color.fromRGBO(81, 172, 135, 1),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_outlined),
                label: '',
                backgroundColor: Color.fromRGBO(81, 172, 135, 1),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
                backgroundColor: Color.fromRGBO(81, 172, 135, 1),
              ),
            ],
          ),
          Positioned(
            top: -10,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () => {},
            ),
          )
        ],
      ),
    );
  }
}
