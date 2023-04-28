import 'package:flutter/material.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({Key? key, required this.vidName, required this.vidFile})
      : super(key: key);
  final String vidName;
  final String vidFile;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        InkWell(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: ListTile(
            title: Text(widget.vidName),
            subtitle: Text(widget.vidFile),
            trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          ),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            // height: min(widget.orders.products.length * 19.0 + 10, 100),
            height: 300,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/line.jpg',
                  height: 300,
                  width: 450,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
      ]),
    );
  }
}
