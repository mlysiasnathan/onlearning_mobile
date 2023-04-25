import 'package:app/widgets/lesson_get_started.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/constants.dart';
import '../routes/lesson_screen.dart';

class LessonItem extends StatelessWidget {
  final int? lesId;
  final String? lesName;
  final String? lesImg;
  final String? lesContent;
  final int? lesPrice;
  final String? createdAt;
  final String? catName;

  const LessonItem({
    super.key,
    this.lesId,
    this.lesName,
    this.lesImg,
    this.lesContent,
    this.lesPrice,
    this.createdAt,
    this.catName,
  });
  void selectCourse(BuildContext context) {
    Navigator.of(context).pushNamed(
      LessonScreen.routeName,
      arguments: {
        'lesName': lesName,
        'lesImg': lesImg,
        'catName': catName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.blue,
      onTap: () => selectCourse(context),
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
                  child: Image.network(
                    '${assetsURL}/storage/${lesImg!}',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                      lesName!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
                      lesContent!,
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
                  top: 130,
                  left: 8,
                  child: Container(
                    width: mediaQuery.size.width * 0.7,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: const LessonGetStarted(),
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
                      const Icon(
                        Icons.schedule_outlined,
                        color: Color.fromRGBO(90, 90, 243, 0.7607843137254902),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Created at : ${DateFormat.yMMMd().format(
                          DateFormat("yyyy-MM-dd'T'H:mm:ss.SSS'Z'").parse(
                            createdAt.toString(),
                          ),
                        )}',
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.monetization_on,
                        color: Color.fromRGBO(90, 90, 243, 0.7607843137254902),
                      ),
                      const SizedBox(width: 5),
                      Text('$lesPrice'),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
