
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
        Container(
          width: 350,
          height: 180,
          decoration: BoxDecoration(
              color: const Color(-2500135),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Image.file(File(widget.listimg[0]),height: 180,fit: BoxFit.cover,),
        ),
        Row(
          children: [
            Container(
              width: 130,
              height: 160,
              decoration: BoxDecoration(
                  color: const Color(-2500135),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Image.file(File(widget.listimg[1]),height: 160,fit: BoxFit.cover,),
            ),
            const SizedBox(width: 5,),

            Expanded(
              child: Container(
                width: 140,
                height: 160,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Image.file(File(widget.listimg[2]),height: 120,fit: BoxFit.cover,),
              ),
            ),
          ],
        )
      ],
    );
  }
}
