import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../routes/screens.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context);
    void goBack() {
      Timer(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed('/');
      });
    }

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
                '$assetsURL/storage/${userData.user.image!}',
                fit: BoxFit.cover,
              ).image,
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
              title: const Text('Edit profile'),
              onTap: () {
                // Navigator.pop(context);
                Navigator.of(context)
                    .popAndPushNamed(EditProfileScreen.routeName);
              }),
          const Divider(color: Color.fromRGBO(90, 90, 243, 1)),
          ListTile(
            title: const Text('Current course'),
            onTap: () {},
          ),
          const Divider(color: Color.fromRGBO(90, 90, 243, 1)),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  showCloseIcon: true,
                  closeIconColor: Colors.white,
                  content: const Text('LOGOUT    Are you sure ?'),
                  duration: const Duration(seconds: 10),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  action: SnackBarAction(
                    textColor: Colors.red,
                    label: 'Yes',
                    onPressed: () {
                      userData.logout();
                      goBack();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
