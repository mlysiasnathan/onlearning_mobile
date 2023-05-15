import 'package:flutter/material.dart';

import '../providers/constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final dynamic image;
  const CustomAppBar({super.key, required this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 7,
      shadowColor: const Color.fromRGBO(90, 90, 243, 1),
      backgroundColor: const Color.fromRGBO(241, 241, 241, 0.9450980392156862),
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 130.0,
      centerTitle: true,
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: const Icon(
              Icons.menu,
              color: Color.fromRGBO(90, 90, 243, 1),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(90, 90, 243, 1),
          ),
        ),
        background: image == null
            ? Image.asset(
                'assets/images/line.jpg',
                fit: BoxFit.cover,
              )
            : Image.network(
                '$assetsURL/storage/$image',
                fit: BoxFit.cover,
              ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: CircleAvatar(
            radius: 9,
            backgroundColor: const Color.fromRGBO(90, 90, 243, 1),
            child: Image.asset(
              'assets/images/onlearning_logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
