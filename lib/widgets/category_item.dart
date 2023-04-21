import 'package:flutter/material.dart';

import '../providers/constants.dart';
import '../routes/category_details.dart';

class CategoryItem extends StatelessWidget {
  final int? catId;
  final String? catName;
  final String? catImg;
  final String? catDescription;

  const CategoryItem({
    super.key,
    required this.catId,
    required this.catName,
    required this.catImg,
    required this.catDescription,
  });
  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      CategoryDetailsScreen.routeName,
      arguments: {
        // 'id': id,
        // 'catColor': catColor,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13),
                  ),
                  child: Image.network('${assetsURL}/storage/${catImg!}',
                      height: 250, width: double.infinity, fit: BoxFit.cover),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      catName!,
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
                    child: const Text(
                      'created at : --:--',
                      style: TextStyle(
                          fontSize: 17,
                          color:
                              Color.fromRGBO(90, 90, 243, 0.7607843137254902),
                          fontWeight: FontWeight.bold),
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
