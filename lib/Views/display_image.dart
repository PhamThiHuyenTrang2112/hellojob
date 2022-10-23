
import 'dart:io';

import 'package:flutter/cupertino.dart';

class DisplayImage extends StatefulWidget {
  List<dynamic> listimg;


  DisplayImage(this.listimg);

  @override
  State<DisplayImage> createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50,),

        Container(
          width: 327,
          height: 223,
          decoration: BoxDecoration(
              color: const Color(-2500135),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Image.file(File(widget.listimg[0])),
        ),
        Row(
          children: [
            const SizedBox(width: 20,),

            Container(
              width: 157,
              height: 173,
              decoration: BoxDecoration(
                  color: const Color(-2500135),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Image.file(File(widget.listimg[1])),
            ),
            const SizedBox(width: 5,),

            Container(
              width: 157,
              height: 173,
              decoration: BoxDecoration(
                  color: const Color(-2500135),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Image.file(File(widget.listimg[2])),
            ),
          ],
        )
      ],
    );
  }
}
