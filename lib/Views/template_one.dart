import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TemplateOne extends StatefulWidget {
  const TemplateOne({Key? key}) : super(key: key);

  @override
  State<TemplateOne> createState() => _TemplateOneState();
}

class _TemplateOneState extends State<TemplateOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                //_onAddImageClick(index);
              },
            ),
          ),
          Row(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    //_onAddImageClick(index);
                  },
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    //_onAddImageClick(index);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
