import 'package:flutter/material.dart';


class RankingList extends StatefulWidget {
  final double height;
  final int pickedIndex;
  final int listSize;
  final NullableIndexedWidgetBuilder builder;
  final Widget pickedItem;
  const RankingList({super.key, required this.height, required this.pickedIndex,  required this.pickedItem, required this.builder, required this.listSize,});

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  late int pickedIndex;
  late double height;
  late bool show = true;
  bool firstCheck = true;
  Alignment alignment = Alignment.bottomCenter;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    height = widget.height;
    pickedIndex = widget.pickedIndex;
    //process scrolling
    scrollController.addListener(() {
      double itemSize = (height + scrollController.position.maxScrollExtent) / 100;
      double itemDes = itemSize * (pickedIndex + 1);
      if(scrollController.position.pixels > itemSize * pickedIndex){
        setState(() {
          alignment = Alignment.topCenter;
          show = true;
        });
      } else
      if(scrollController.position.pixels + height > itemDes){
        setState(() {
          show = false;
          alignment = Alignment.bottomCenter  ;
        });
      } else
      if(scrollController.position.pixels + height < itemDes){
        setState(() {
          show = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(firstCheck){
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        scrollController.jumpTo(0.01);
        firstCheck = false;
      });
    }
    return Container(
      color: Colors.black,
      height: height,
      child: Stack(
        children: [
          ListView.builder(
            controller: scrollController,
            itemCount: widget.listSize,
            itemBuilder: widget.builder,
          ),
          show ? Align(
            alignment: alignment,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 6
                  )
                ]
              ),
              child: widget.pickedItem,
            ),
          ) : Container()
        ],
      ),
    );
  }
}
