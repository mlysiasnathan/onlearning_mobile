import 'package:flutter/material.dart';

import '../providers/providers.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final dynamic image;
  const CustomAppBar({super.key, required this.title, this.image});

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;
    return SliverAppBar(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 7,
      shadowColor:primaryColor,
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
            icon:  Icon(
              Icons.menu,
              color: primaryColor,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: FittedBox(
          child: Text(
            title,
            style:  TextStyle(
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),
        ),
        background: image == null
            ? Image.asset(
                assetImages[5],
                fit: BoxFit.cover,
              )
            : Hero(
                tag: image,
                child: FadeInImage(
                  fadeInDuration: const Duration(seconds: 1),
                  fadeOutDuration: const Duration(seconds: 1),
                  fit: BoxFit.cover,
                  placeholder: AssetImage(
                    assetImages[3],
                  ),
                  image: NetworkImage(
                    '$assetsURL/storage/$image',
                  ),
                ),
              ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
              assetImages[1],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
