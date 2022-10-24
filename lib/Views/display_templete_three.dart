import 'dart:io';
import 'package:flutter/cupertino.dart';

class DisplayTempleteThree extends StatefulWidget {
  List<dynamic> listimg;
  DisplayTempleteThree(this.listimg);

  @override
  State<DisplayTempleteThree> createState() => _DisplayTempleteThreeState();
}
class _DisplayTempleteThreeState extends State<DisplayTempleteThree> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          children: [
            Container(
              width: 130,
              height: 160,
              decoration: BoxDecoration(
                  color: const Color(-2500135),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Image.file(File(widget.listimg[0]),height: 160,fit: BoxFit.cover,),
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
                child: Image.file(File(widget.listimg[1]),height: 120,fit: BoxFit.cover,),
              ),
            ),
          ],
        ),
        Container(
          width: 350,
          height: 180,
          decoration: BoxDecoration(
              color: const Color(-2500135),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Image.file(File(widget.listimg[2]),height: 180,fit: BoxFit.cover,),
        ),
      ],
    );
  }
}
