import 'package:flutter/material.dart';


class CategoryItem extends StatelessWidget {
  final String id;
  final Color catColor;
  final String name;
  final String imgUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final Function removeItem;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.duration,
    required this.complexity,
    required this.affordability,
    this.catColor = Colors.green,
    required this.removeItem,
  });
  void selectMeal(BuildContext context) {
    Navigator.of(context).pushNamed(
      MealDetailsScreen.routeName,
      arguments: {
        'id': id,
        'catColor': catColor,
      },
    ).then((resultFromPopedPage) {
      if (resultFromPopedPage != null) {
        removeItem(resultFromPopedPage);
      }
    });
  }

  String get complexityText {
    switch (complexity) {
      case Complexity.Simple:
        return 'Simple';
        break;
      case Complexity.Hard:
        return 'Hard';
        break;
      case Complexity.Challenging:
        return 'Challenging';
        break;
      default:
        return 'Unknown Complexity';
    }
    // if (complexity == Complexity.Simple) {
    //   return 'Simple';
    // } else if (complexity == Complexity.Hard) {
    //   return 'Hard';
    // } else {
    //   return 'Challenging';
    // }
  }

  String get affordabilityText {
    switch (affordability) {
      case Affordability.Luxurious:
        return 'Expensive';
        break;
      case Affordability.Affordable:
        return 'Affordable';
        break;
      case Affordability.Pricey:
        return 'Pricey';
        break;
      default:
        return 'Unknown Affordability';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
                child: Image.network(imgUrl,
                    height: 250, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 26,
                right: 10,
                child: Container(
                  color: Colors.black,
                  width: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  // decoration:
                  //     BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    softWrap: true,
                    overflow: TextOverflow.fade,
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
                      const Icon(Icons.schedule_outlined),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      Text('$duration min'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.workspace_premium),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(complexityText),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.attach_money),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(affordabilityText),
                    ],
                  )
                ]),
          )
        ]),
      ),
    );
  }
}
