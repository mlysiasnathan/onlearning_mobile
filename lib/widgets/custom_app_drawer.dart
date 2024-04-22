import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../routes/screens.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

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
                 BoxDecoration(color: primaryColor),
            accountName: Text('${userData.user.userName}'),
            accountEmail: Text('${userData.user.userEmail}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: userData.user.userName == 'Student' &&
                      userData.user.userEmail == 'unkown@test.com' &&
                      userData.user.userId == 0
                  ? Image.asset(
                      userData.user.image.toString(),
                      fit: BoxFit.cover,
                    ).image
                  : Image.network(
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
              if (userData.user.userName == 'Student' &&
                  userData.user.userEmail == 'unkown@test.com' &&
                  userData.user.userId == 0) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    closeIconColor: Colors.white,
                    backgroundColor: Colors.red,
                    content: const Text('You cannot edit without network'),
                    duration: const Duration(seconds: 10),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
              } else {
                Navigator.of(context)
                    .popAndPushNamed(EditProfileScreen.routeName);
              }
            },
          ),
           Divider(color: primaryColor),
          ListTile(
            title: const Text('Current course'),
            onTap: () {},
          ),
          Divider(color: primaryColor),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (userData.user.userName == 'Student' &&
                  userData.user.userEmail == 'unkown@test.com' &&
                  userData.user.userId == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    closeIconColor: Colors.white,
                    backgroundColor: Colors.red,
                    content: const Text('You cannot logout without network'),
                    duration: const Duration(seconds: 10),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
              } else {
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
              }
            },
          ),
        ],
      ),
    );
  }
}
