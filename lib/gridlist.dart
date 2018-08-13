import 'package:flutter/material.dart';

class GridList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new GridListState();
  }

}

class GridListState extends State<GridList>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Grid List"),
      ),
      body: new GridView.count(
        crossAxisCount: 3,
        children: new List.generate(100, (index){
          return new Center(
              child: new Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline,
              )
          );
        }),
      ),
    );
  }
}