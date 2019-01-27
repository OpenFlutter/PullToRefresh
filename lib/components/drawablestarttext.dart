import 'package:flutter/material.dart';

class DrawableStartText extends StatefulWidget{

  final TextStyle textStyle;
  final String text;
  final String assetImage;
  final int maxLines;
  ///尽可能写出图片后大概有多少字母，这样能快速计算第一行显示多少个字母（例如有20个字母  可以设置该值为12左右），默认为0
  //final int lettersCountOfAfterImage;

  DrawableStartText({
    this.textStyle,
    @required this.text,
    @required this.assetImage,
    this.maxLines,
    //this.lettersCountOfAfterImage:0,
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
    //计算文字的高度，根据文字的高度设定图片的高度，然后让图片自适应
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

    //在第一帧后计算下第一行能显示多少个字母，然后将字母分成两段显示
    WidgetsBinding.instance.addPostFrameCallback((callback){
      _image.image.resolve(new ImageConfiguration())
          .addListener((imageInfo,synchronousCall){
        //计算图片的宽高
        double imgHeight = imageInfo.image.height . toDouble();
        double imgWidth = imageInfo.image.width . toDouble();
        //由于图片缩放了。所以根据缩放大小计算出宽图，这里没有用key去取值，是因为取出的值是空的
        double scale=_textHeight/imgHeight;
        double _imageWidth=imgWidth*scale;

        //再用父控件的宽度减去图片的宽度就是文字显示的宽度
        double parentWidth = rowKey.currentContext.findRenderObject().paintBounds.size.width;
        double textWidth = parentWidth - _imageWidth;

        int index=0;
        //计算出在哪个字母时超出了显示范围
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

        //将超出的哪个位置减掉，剩下的字母就不会超出范围了
        int validIndex=index-1;
        //根据计算的位置，分别截取前半部分 和后半部分显示
        setState(() {
          _topText=  widget.text.substring(0,validIndex);
          _bottomText =  widget.text.substring(validIndex);
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
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
          maxLines: widget.maxLines ==null ? defaultTextStyle.maxLines : widget.maxLines-1,
          overflow: widget.maxLines ==null ? defaultTextStyle.overflow : TextOverflow.ellipsis,
        ),
      ],
    );
  }
}