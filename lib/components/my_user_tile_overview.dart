import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class MyUserTileOverview extends StatefulWidget {
  final String userName;
  final String msg;
  bool isSelected;
  MyUserTileOverview({
    super.key,
    this.isSelected = false,
    required this.userName,
    required this.msg,
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
      child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: widget.isSelected ? Border.all(color: Colors.blue) : null,
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.msg,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
