import 'package:flutter/material.dart';

import '../helpers/constants.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: const BorderSide(color: Colors.blue, width: 1),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 60,
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.play_circle_outline),
                  const SizedBox(width: 10),
                  Expanded(child: Text(widget.vidName)),
                  Icon(_expanded ? Icons.expand_more : Icons.chevron_right),
                ],
              ),
            ),
          ),
          // if (_expanded)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            height: _expanded ? 220 : 0,
            child: Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      assetImages[5],
                      height: 200,
                      width: 450,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(child: Text(widget.vidFile)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
