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
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Container(
              height: 60,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.play_circle_outline),
                  Text(widget.vidName),
                  Icon(_expanded ? Icons.expand_more : Icons.chevron_right),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              height: 220,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/line.jpg',
                    height: 200,
                    width: 450,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
