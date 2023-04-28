import 'package:flutter/material.dart';

import '../providers/constants.dart';
import '../providers/user_services.dart';
import '../routes/auth_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(90, 90, 243, 1)),
            accountName: Text('${user.userName}'),
            accountEmail: Text('${user.userEmail}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: Image.network(
                '${assetsURL}/storage/${user.image!}',
                fit: BoxFit.cover,
              ).image,
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: const Text('Edit profile'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Current course'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              logout().then(
                (value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                    (route) => false),
              );
            },
          ),
        ],
      ),
    );
  }
}
