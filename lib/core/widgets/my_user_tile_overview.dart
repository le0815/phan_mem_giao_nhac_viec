import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:slideable/slideable.dart';

class MyUserTileOverview extends StatefulWidget {
  final String userName;
  final String msg;
  bool isSelected;
  final Function() onRemove;
  MyUserTileOverview({
    super.key,
    this.isSelected = false,
    required this.userName,
    required this.msg,
    required this.onRemove,
  });

  @override
  State<MyUserTileOverview> createState() => MyUserTileOverviewState();
}

class MyUserTileOverviewState extends State<MyUserTileOverview> {
  changeState() {
    setState(() {
      widget.isSelected = !widget.isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Slideable(
        items: [
          ActionItems(
            icon: Icon(Icons.delete_outline),
            onPress: widget.onRemove,
            backgroudColor: Colors.transparent,
          ),
        ],
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? Theme.of(context).primaryColor
                  : ThemeConfig.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.people_alt_outlined),
                AddHorizontalSpace(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.msg,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
