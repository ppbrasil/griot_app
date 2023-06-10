import 'package:flutter/material.dart';

class AccountsListPage extends StatefulWidget {
  const AccountsListPage({super.key});

  @override
  State<AccountsListPage> createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
