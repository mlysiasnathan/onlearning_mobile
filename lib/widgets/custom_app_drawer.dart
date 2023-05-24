import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/constants.dart';
import '../providers/users_provider.dart';
import '../routes/auth_screen.dart';
import '../routes/edit_profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Users>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(90, 90, 243, 1)),
            accountName: Text('${userData.user.userName}'),
            accountEmail: Text('${userData.user.userEmail}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: Image.network(
                '${assetsURL}/storage/${userData.user.image!}',
                fit: BoxFit.cover,
              ).image,
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
              title: const Text('Edit profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(EditProfileScreen.routeName);
              }),
          ListTile(
            title: const Text('Current course'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              userData.logout().then(
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
