import 'package:flutter/material.dart';

class DrawableStartTextDemo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("DrawableStartText"),
      ),
      body: new Center(
        child: new Container(
          child: new DrawableStartText(
            assetImage: "images/tianmao.jpg",
            text: " 莫顿 全自动感应壁挂式酒精喷雾式手消毒器 手消毒机杀菌净手器",
            textStyle: new TextStyle(fontSize: 17.0),
          ),
        ),
      ),
    );
  }
}


class DrawableStartText extends StatefulWidget{

  final TextStyle textStyle;
  final String text;
  final String assetImage;

  DrawableStartText({
    this.textStyle,
    @required this.text,
    @required this.assetImage,
  });

  @override
  State<StatefulWidget> createState() {
    return new DrawableStartTextState();
  }
}



class DrawableStartTextState extends State<DrawableStartText>{

  double _textHeight;
  GlobalKey rowKey=GlobalKey();
  GlobalKey imageKey=GlobalKey();
  String _topText="";
  String _bottomText="";
  Image _image;

  @override
  void initState() {
    super.initState();
    TextPainter painter=new TextPainter();
    if(widget.textStyle!=null) {
      painter.text = TextSpan(style: widget.textStyle, text: widget.text);
    }else{
      painter.text = TextSpan(text: widget.text);
    }
    painter.maxLines=1;
    painter.textDirection=TextDirection.ltr;
    painter.layout();
    _textHeight=painter.size.height;


    WidgetsBinding widgetsBinding=WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback){

      _image.image.resolve(new ImageConfiguration())
          .addListener((imageInfo,synchronousCall){
        double imgHeight = imageInfo.image.height . toDouble();
        double imgWidth = imageInfo.image.width . toDouble();

        double scale=_textHeight/imgHeight;
        double _imageWidth=imgWidth*scale;

        double parentWidth = rowKey.currentContext.findRenderObject().paintBounds.size.width;
        double textWidth = parentWidth - _imageWidth;

        int index=10;
        for(;index<widget.text.length;index++){
          if(widget.textStyle!=null) {
            painter.text = TextSpan(style: widget.textStyle, text: widget.text.substring(0,index));
          }else{
            painter.text = TextSpan(text: widget.text.substring(0,index));
          }
          painter.layout();
          if(painter.size.width>textWidth){
            break;
          }
        }

        int validIndex=index-1;
        setState(() {
          _topText=  widget.text.substring(0,validIndex);
          _bottomText =  widget.text.substring(validIndex);
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          key: rowKey,
          children: <Widget>[
            _image=new Image.asset(
              widget.assetImage,
              key:imageKey,
              height:_textHeight,
              fit : BoxFit.fitHeight,
            ),
            new Text(
              _topText,
              style: widget.textStyle,
              maxLines: 1,
            ),
          ],
        ),
        new Text(
          _bottomText,
          style: widget.textStyle,
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}