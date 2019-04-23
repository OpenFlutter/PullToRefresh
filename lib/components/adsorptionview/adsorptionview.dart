import 'package:flutter/material.dart';
import 'package:flutterapp/bin/adsorptiondatabin.dart';
import 'package:flutterapp/components/adsorptionview/equalHeightState.dart';
import 'package:flutterapp/components/adsorptionview/notEqualHeightState.dart';

typedef Widget GetHearWidget <M extends AdsorptionData> (M bin);
typedef Widget GetGeneralItem <M extends AdsorptionData> (M bin);

class AdsorptionView<T extends AdsorptionData> extends StatefulWidget{

  final List<T> adsorptionDatas;
  final GetHearWidget<T> headChild;
  final GetGeneralItem<T> generalItemChild;
  final double itemHeight;
  final double itemWidth;
  final double cacheExtent;
  final bool isEqualHeightItem;

  AdsorptionView({
    @required this.adsorptionDatas,
    @required this.headChild,
    @required this.generalItemChild,
    this.itemHeight:50.0,
    this.itemWidth:double.infinity,
    this.cacheExtent:30.0,
    @required this.isEqualHeightItem,
  }): assert(
    adsorptionDatas!=null,
    generalItemChild!=null&&
    headChild!=null,
  );

  @override
  State<StatefulWidget> createState() {
    if(isEqualHeightItem) {
      return new AdsorptionViewState<T>();
    }else{
      return new AdsorptionViewNotEqualHeightState<T>();
    }
  }
}



