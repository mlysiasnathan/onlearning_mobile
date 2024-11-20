import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';
import '../routes/screens.dart';

class CategoryItem extends StatelessWidget {
  final int? catId;
  final String? catName;
  final String? catImg;
  final String? catDescription;
  final String? createdAt;

  const CategoryItem({
    super.key,
    required this.catId,
    required this.catName,
    required this.catImg,
    required this.catDescription,
    required this.createdAt,
  });
  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      CategoryDetailsScreen.routeName,
      arguments: {'catName': catName, 'catImg': catImg},
    );
  }

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: primaryColor,
      onTap: () => selectCategory(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Hero(
                    tag: catImg!,
                    child: FadeInImage(
                      fadeInDuration: const Duration(seconds: 1),
                      fadeOutDuration: const Duration(seconds: 1),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: AssetImage(
                          assetImages[3],
                      ),
                      image:
                          // precacheImage(
                          NetworkImage(
                        '$assetsURL/storage/${catImg!}',
                      ),
                      // context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                      primaryColor,
                    ),
                    width: 300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: FittedBox(
                      child: Text(
                        catName!.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 110,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                      primaryColor,
                    ),
                    width: 300,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      catDescription!,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned(
                  top: 190,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 300,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Created at : ${DateFormat.yMMMd().format(
                        DateFormat("yyyy-MM-dd'T'H:mm:ss.SSS'Z'").parse(
                          createdAt.toString(),
                        ),
                      )}',
                      style:  TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
