import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DismissibleItem extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new DismissibleItemState(
        new List<String>.generate(20, (i) => "Item ${i + 1}")
    );
  }
}

class DismissibleItemState extends State<DismissibleItem>{

  final List<String> items;

  DismissibleItemState(this.items);
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Dismissing Items"),
      ),
      body: new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context,index){
          final item=items[index];
          return new Dismissible(
            key: new Key(item),
            onDismissed: (direction){
              items.removeAt(index);
              Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text("$item dismissed")));
            },
            background: new Container(color: Colors.red,),
            child: new ListTile(title: new Text("$item"),),
          );
        }
      ),
    );
  }

}