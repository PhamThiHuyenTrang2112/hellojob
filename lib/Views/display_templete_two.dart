
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class DisplayTempleteTwo extends StatefulWidget {
  List<dynamic> listimg;


  DisplayTempleteTwo(this.listimg);

  @override
  State<DisplayTempleteTwo> createState() => _DisplayTempleteTwoState();
}

class _DisplayTempleteTwoState extends State<DisplayTempleteTwo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 122,
              height: 290,
              decoration: BoxDecoration(
                  color: const Color(-2500135),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: FullScreenWidget(child: Image.file(File(widget.listimg[0]),height: 120,fit: BoxFit.cover,)),
            ),
            const SizedBox(width: 5,),
            Container(
              width: 122,
              height: 290,
              decoration: BoxDecoration(
                  color: const Color(-2500135),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: FullScreenWidget(child: Image.file(File(widget.listimg[1]),height: 120,fit: BoxFit.cover!)),
            ),
          ],
        ),
        const SizedBox(height: 5,),
        Row(
          children: [
           Container(
              width: 122,
              height: 290,
              decoration: BoxDecoration(
                  color: const Color(-2500135),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: FullScreenWidget(child: Image.file(File(widget.listimg[2]),height: 120,fit: BoxFit.cover)),
            ),
            const SizedBox(width: 5,),
            Container(
              width: 122,
              height: 290,
              decoration: BoxDecoration(
                  color: const Color(-2500135),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: FullScreenWidget(
                  child: Image.file(File(widget.listimg[3]),height: 120,fit: BoxFit.cover)
              ),
            ),
          ],
        )
      ],
    );
  }
}
