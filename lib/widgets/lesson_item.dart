import 'package:app/widgets/lesson_get_started.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';

class LessonItem extends StatelessWidget {
  final int? lesId;
  final String? lesName;
  final String? lesImg;
  final String? lesContent;
  final int? lesPrice;
  final String? createdAt;
  final String? catName;
  final List<dynamic>? tags;

  const LessonItem({
    super.key,
    this.lesId,
    this.lesName,
    this.lesImg,
    this.lesContent,
    this.lesPrice,
    this.createdAt,
    this.catName,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Card(
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
                  tag: lesImg!,
                  child: FadeInImage(
                    fadeInDuration: const Duration(seconds: 1),
                    fadeOutDuration: const Duration(seconds: 1),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage(
                      'assets/images/placeholder.PNG',
                    ),
                    image: NetworkImage(
                      '$assetsURL/storage/${lesImg!}',
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
                    color:primaryColor,
                  ),
                  width: 300,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child:
                      // FittedBox(
                      //   child:
                      Text(
                    lesName!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // ),
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
                    lesContent!,
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                     Icon(
                      Icons.schedule_outlined,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat.yMMMd().format(
                        DateFormat("yyyy-MM-dd'T'H:mm:ss.SSS'Z'").parse(
                          createdAt.toString(),
                        ),
                      ),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                     Icon(
                      Icons.monetization_on,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text('$lesPrice'),
                  ],
                ),
                Row(
                  children: <Widget>[
                     Icon(
                      Icons.chevron_right,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    LessonGetStarted(
                      lesName: lesName,
                      lesImg: lesImg,
                      catName: catName,
                      tags: tags ?? [],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
