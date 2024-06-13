import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../helpers/constants.dart';

class ProxyScreen extends StatefulWidget {
  const ProxyScreen({super.key});

  @override
  State<ProxyScreen> createState() => _ProxyScreenState();
}

class _ProxyScreenState extends State<ProxyScreen> {
  var _isLoading = false;
  late String _newIp = '';

  @override
  Widget build(BuildContext context) {
    // final Color primaryColor = Theme.of(context).primaryColor;
    final ThemeData theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context).size;
    final userData = Provider.of<Auth>(context, listen: false);
    void submit() {
      if (_newIp.trim() == '') {
        return;
      }
      setState(() {
        _isLoading = true;
      });
      userData.changeIpAddress(newIpAddress: _newIp);
    }

    return Scaffold(
      body: Container(
        color: theme.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 70.0),
              transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: theme.colorScheme.shadow,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                'Onlearning',
                style: TextStyle(
                  fontSize: 30,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 19,
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/onlearning_logo.jpg',
                  width: mediaQuery.height * 0.20,
                  height: mediaQuery.height * 0.20,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: ipLocalAddress,
                        key: const ValueKey('wifi'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900),
                        decoration: InputDecoration(
                          fillColor: theme.colorScheme.background,
                          filled: true,
                          isDense: true,
                          prefixIcon: const Icon(Icons.wifi),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                          hintText: 'Local IP Address :',
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Enter a valid IP Address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _newIp = value!.trim();
                          submit();
                        },
                        onChanged: (value) {
                          _newIp = value.trim();
                        },
                        onFieldSubmitted: (value) {
                          _newIp = value.trim();
                          submit();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.background,
                      child: IconButton(
                        onPressed: submit,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: theme.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              )
            else
              LinearProgressIndicator(
                backgroundColor: theme.primaryColor,
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
          ],
        ),
      ),
    );
  }
}
