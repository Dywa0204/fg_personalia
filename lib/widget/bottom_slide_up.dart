import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomSlideUp extends StatefulWidget {
  final Widget child;
  final Widget body;
  final double? padding;
  final bool? isScrollable;
  final VoidCallback? onPanelClosed;
  final Widget? header;
  final Widget? headerMore;
  final Function(PanelController)? onPanelCreated;
  final VoidCallback? onPanelOpen;

  BottomSlideUp({
    Key? key,
    required this.child,
    required this.body,
    this.padding,
    this.onPanelCreated,
    this.isScrollable,
    this.onPanelClosed,
    this.header,
    this.onPanelOpen,
    this.headerMore,
  }) : super(key: key);

  @override
  State<BottomSlideUp> createState() => BottomSlideUpState();
}

class BottomSlideUpState extends State<BottomSlideUp> {
  final panelController = PanelController();
  late double maxHeight;
  late double minHeight;

  @override
  void initState() {
    super.initState();
    if (widget.onPanelCreated != null) {
      widget.onPanelCreated!(panelController);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maxHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top - 48;
    minHeight = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        backdropEnabled: true,
        controller: panelController,
        onPanelOpened: widget.onPanelOpen,
        parallaxEnabled: false,
        maxHeight: maxHeight,
        minHeight: minHeight,
        panelBuilder: (scrollController) => buildSlidingPanel(
          context,
          scrollController: scrollController,
          panelController: panelController,
        ),
        body: widget.body,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        onPanelClosed: widget.onPanelClosed,
      ),
    );
  }

  Widget buildSlidingPanel(
      BuildContext context, {
        required PanelController panelController,
        required ScrollController scrollController,
      }) {
    bool useScroll = widget.isScrollable ?? true;

    if (useScroll) {
      return ListView(
        padding: EdgeInsets.all(widget.padding ?? 0),
        controller: scrollController,
        children: [
          Column(
            children: [
              buildDragIcon(context),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: widget.child,
          ),
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildDragIcon(context),
            if (widget.header != null) widget.header!,
            if (widget.headerMore != null) widget.headerMore!,
            widget.child,
            SizedBox(height: 16),
          ],
        ),
      );
    }
  }

  Widget buildDragIcon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width * 0.1,
      height: 6,
      margin: EdgeInsets.symmetric(vertical: 8),
    );
  }

  void setMaxHeight({double? maxHeightPercentage, double? maxHeightFixed}) {
    setState(() {
      if (maxHeightPercentage != null) {
        maxHeight = MediaQuery.of(context).size.height * maxHeightPercentage;
      } else if (maxHeightFixed != null) {
        maxHeight = maxHeightFixed;
      } else {
        maxHeight = MediaQuery.of(context).size.height * 0.7;
      }
    });
  }

  void setMinHeight({double? minHeightPercentage, double? minHeightFixed}) {
    setState(() {
      if (minHeightPercentage != null) {
        minHeight = MediaQuery.of(context).size.height * minHeightPercentage;
      } else if (minHeightFixed != null) {
        minHeight = minHeightFixed;
      } else {
        minHeight = MediaQuery.of(context).size.height * 0.7;
      }
    });
  }
}
