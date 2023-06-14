import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GriotBottomNavigationBar extends StatefulWidget {
  const GriotBottomNavigationBar({super.key});

  @override
  State<GriotBottomNavigationBar> createState() =>
      _GriotBottomNavigationBarState();
}

class _GriotBottomNavigationBarState extends State<GriotBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}
