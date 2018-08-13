import 'package:flutter/material.dart';
import './views/ShoppingListItem.dart';

class ShoppingList extends StatefulWidget{

  final List<Product> products=<Product>[
    new Product(name: '鸡蛋'),
    new Product(name: '面粉'),
    new Product(name: '巧克力脆片'),
  ];

  ShoppingList({Key key}) :super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ShoppingListState();
  }
}


class _ShoppingListState extends State<ShoppingList>{

  Set<Product> _shoppingCart=new Set<Product>();

  void _handleCartChanged(Product product,bool inCart){
    setState(
        (){
          if(inCart)
            _shoppingCart.add(product);
          else
            _shoppingCart.remove(product);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("购物清单"),
      ),
      body: new ListView(
        children: widget.products.map((Product product){
          return new ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }

}
