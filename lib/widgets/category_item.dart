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
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.blue,
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: catImg!,
                    child: FadeInImage(
                      fadeInDuration: const Duration(seconds: 1),
                      fadeOutDuration: const Duration(seconds: 1),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: const AssetImage(
                        'assets/images/placeholder.PNG',
                      ),
                      image: NetworkImage(
                        '$assetsURL/storage/${catImg!}',
                      ),
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
                          const Color.fromRGBO(90, 90, 243, 0.7607843137254902),
                    ),
                    width: 300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Text(
                      catName!.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      softWrap: true,
                      overflow: TextOverflow.fade,
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
                          const Color.fromRGBO(90, 90, 243, 0.7607843137254902),
                    ),
                    width: 300,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      catDescription!,
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      softWrap: true,
                      overflow: TextOverflow.fade,
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
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color.fromRGBO(90, 90, 243, 0.7607843137254902),
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
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
